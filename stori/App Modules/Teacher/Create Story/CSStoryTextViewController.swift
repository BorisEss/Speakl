//
//  CSStoryTextViewController.swift
//  stori
//
//  Created by Alex on 30.01.2021.
//

import UIKit
import SwipeCellKit

class CSStoryTextViewController: UIViewController {
    
    var completion: (() -> Void)?
    
    var subCategory: SubCategory? = CreateStoryObject.shared?.subCategory
    var language: Language? = CreateStoryObject.shared?.language
    var languageLevel: LanguageLevel? = CreateStoryObject.shared?.chapter?.languageLevel
    
    var grammarUrl: String?
    var vocabularyId: Int?
    
    var items: [StorySection] = CreateStoryObject.shared?.chapterStoryParts ?? []
     
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var vocabularyButtonTitle: UILabel!
    @IBOutlet weak var vocabularyButtonSubtitle: UILabel!
    @IBOutlet weak var grammarButtonTitle: UILabel!
    @IBOutlet weak var grammarButtonSubtitle: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        preloadGrammar()
        preloadVocabulary()
        
        setUpTableView()
        setUpLanguage()
        
        loadParts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CreateStoryObject.shared?.chapterStoryParts = items
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVc = segue.destination as? WebBrowserViewController {
            if let languageLevel = languageLevel,
               let shortcut = languageLevel.shortcut {
                nextVc.title = "\(shortcut) - \("cs_text_grammar_guide".localized)"
            } else {
                nextVc.title = "cs_text_grammar_guide".localized
            }
            nextVc.url = URL(string: grammarUrl ?? "")
            nextVc.noDataTitle = "cs_text_grammar_missing".localized
        }
        if let nextVc = segue.destination as? CSVocabularyListViewController {
            nextVc.vocabularyId = vocabularyId
        }
    }
    
    private func preloadGrammar() {
        guard let language = language,
              let languageLevel = languageLevel,
              let subCategory = subCategory else {
            return
        }
        CSPresenter.grammar.getGrammar(language: language,
                                       languageLevel: languageLevel,
                                       subCategory: subCategory)
            .done { (grammarUrl) in
                self.grammarUrl = grammarUrl
            }
            .cauterize()
    }
    
    private func preloadVocabulary() {
        guard let language = language,
              let languageLevel = languageLevel,
              let subCategory = subCategory else {
            return
        }
        CSPresenter.vocabulary.getVocabularyId(language: language,
                                               languageLevel: languageLevel,
                                               subCategory: subCategory)
            .done { (vocabularyId) in
                self.vocabularyId = vocabularyId
            }
            .cauterize()
    }
    
    private func setUpLanguage() {
        title = "cs_text_title".localized
        vocabularyButtonTitle.text = "cs_text_vocabulary_list".localized
        grammarButtonTitle.text = "cs_text_grammar".localized
        titleLabel.text = "cs_text_add_title_label_start".localized
        guard let languageLevel = languageLevel,
              let shortcut = languageLevel.shortcut else {
            vocabularyButtonSubtitle.isHidden = true
            grammarButtonSubtitle.isHidden = true
            return
        }
        vocabularyButtonSubtitle.text = "\(shortcut) - \(languageLevel.name)"
        grammarButtonSubtitle.text = "\(shortcut) - \(languageLevel.name)"
    }
    
    private func setUpTableView() {
        tableView.register(CSAddTableViewCell.nib(),
                           forCellReuseIdentifier: CSAddTableViewCell.identifier)
        tableView.register(CSTextItemTableViewCell.nib(),
                           forCellReuseIdentifier: CSTextItemTableViewCell.identifier)
        tableView.register(CSImageItemTableViewCell.nib(),
                           forCellReuseIdentifier: CSImageItemTableViewCell.identifier)
        tableView.register(CSVideoItemTableViewCell.nib(),
                           forCellReuseIdentifier: CSVideoItemTableViewCell.identifier)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 32))
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func loadParts() {
        if CreateStoryObject.shared?.chapterStoryParts == nil {
            guard let chapterId = CreateStoryObject.shared?.chapter?.id else { return }
            CSPresenter.chapterPart.getChapterParts(chapterId: chapterId)
                .done { (sections) in
                    self.items = sections
                    self.tableView.reloadData()
                }
                .cauterize()
        }
    }
}

extension CSStoryTextViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.isEmpty {
            titleLabel.text = "cs_text_add_title_label_start".localized
        } else {
            titleLabel.text = "cs_text_add_title_label_your_story".localized
        }
        return items.count + 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setNeedsLayout()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let chapterId = CreateStoryObject.shared?.chapter?.id else { return UITableViewCell() }
        if items.count == indexPath.row,
           let tCell = tableView.dequeueReusableCell(withIdentifier: CSAddTableViewCell.identifier),
            let cell = tCell as? CSAddTableViewCell {
            cell.createTextHandler = {
                if self.items.allSatisfy({ $0.finishedUpload }) {
                    self.items.append(StorySectionBuilder.createText(chapterId: chapterId))
                    self.asyncInsertRowAtTheEnd()
                } else {
                    Toast.warning("cs_text_wait_until_finished".localized)
                }
            }
            cell.createMediaHandler = { [weak self] file in
                if let item = StorySectionBuilder.createMediaItem(chapterId: chapterId, file: file) {
                    self?.items.append(item)
                    self?.asyncInsertRowAtTheEnd()
                }
            }
            return cell
        } else if indexPath.row < items.count {
            if let cell = CSTableViewCellBuilder.buildCell(with: items[indexPath.row], in: tableView) {
                if items[indexPath.row].finishedUpload {
                    cell.delegate = self
                } else {
                    items[indexPath.row].didFinishUpload = {
                        cell.delegate = self
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
                cell.editActionCallback = {
                    switch self.items[indexPath.row].type {
                    case .text: break
                    case .image:
                        ImagePicker.pickImage(from: .library,
                                              frontCamera: false) { (image) in
                            (self.items[indexPath.row] as? StoryImageSection)?.updateImage(newImage: image)
                            self.tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                    case .video:
                        ImagePicker.pickVideo(from: .library) { (video) in
                            (self.items[indexPath.row] as? StoryVideoSection)?.updateVideo(newVideo: video)
                            self.tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
                (cell as? CSTextItemTableViewCell)?.updateView = {
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    private func asyncInsertRowAtTheEnd() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(item: self.items.count - 1, section: 0)],
                                       with: .automatic)
            self.tableView.endUpdates()
        }
    }
}

extension CSStoryTextViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath,
                   for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        switch orientation {
        case .left: return nil
        case .right:
            if indexPath.row < items.count,
               items[indexPath.row].finishedUpload {
                let remove = SwipeAction(style: .destructive, title: nil) { (_, indexPath) in
                    CSPresenter.chapterPart.removeChapterPart(part: self.items[indexPath.row])
                    self.items.remove(at: indexPath.row)
                }
                remove.title = "common_remove_title".localized
                remove.textColor = .removeRed
                remove.font = .IBMPlexSans(size: 12)
                remove.image = UIImage(named: "remove")
                remove.backgroundColor = .background
                return [remove]
            } else { return nil}
        }
    }
    
    func tableView(_ tableView: UITableView,
                   editActionsOptionsForRowAt indexPath: IndexPath,
                   for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .drag
        options.buttonPadding = 8
        options.buttonSpacing = 2
        options.backgroundColor = .background
        return options
    }
}
