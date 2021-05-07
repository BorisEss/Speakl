//
//  UpdateLanguageLevelVocabularyVC.swift
//  stori
//
//  Created by Alex on 04.05.2021.
//

import UIKit
import PaginatedTableView

class UpdateLanguageLevelVocabularyVC: UIViewController {
    
    var language: Language?
    var level: LanguageLevel?
    
    var wordCountUpdated: ((Int) -> Void)?
    var openWebBrowser: ((URL) -> Void)?
        
    private var words: [String: [VocabularyWord]] = [:] {
        didSet {
            sectionIndexes = [String](words.keys)
            sectionIndexes.sort(by: { $0 < $1 })
        }
    }
    private var sectionIndexes: [String] = []
    private var wordsCount: Int = 0 {
        didSet {
            wordCountUpdated?(wordsCount)
        }
    }
    private var page: Int = 1 {
        didSet {
            if page == 1 {
                canContinueToNextPage = true
                words = [:]
            }
        }
    }
    private var canContinueToNextPage: Bool = true
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appendWords(newWords: nil)
        self.loadData(page: self.page)
    }
    
    private func setUpTableView() {
        tableView.register(VocabularyItemTableViewCell.nib(),
                           forCellReuseIdentifier: VocabularyItemTableViewCell.identifier)
        tableView.register(VocabularyHeaderTableViewCell.nib(),
                           forCellReuseIdentifier: VocabularyHeaderTableViewCell.identifier)
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 16))
        footerView.backgroundColor = .clear
        tableView.tableFooterView = footerView
    }
    
    private func loadData(page: Int) {
        guard let language = language,
              let level = level else {
            self.canContinueToNextPage = false
            self.tableView.reloadData()
            return
        }
        UpdateLanguageLevelPresenter().getWords(language: language,
                                                languageLevel: level,
                                                page: page)
            .done { (response) in
                self.canContinueToNextPage = false
                self.canContinueToNextPage = response.next != nil
                self.wordsCount = response.count
                self.appendWords(newWords: response.results)
            }
            .ensure {
                self.tableView.reloadData()
            }
            .cauterize()
    }
    
    private func appendWords(newWords: [VocabularyWord]?) {
        guard let newWords = newWords else {
            words = [:]
            return
        }
        var oldWords = words.flatMap { $1 }
        oldWords.append(contentsOf: newWords)
        oldWords.sort(by: {$0.word < $1.word})
        var outputDict = [String: [VocabularyWord]]()
        for word in oldWords {
            let initialLetter = word.word[..<word.word.index(word.word.startIndex, offsetBy: 1)].uppercased()
            var letterArray = outputDict[initialLetter] ?? [VocabularyWord]()
            letterArray.append(word)
            outputDict[initialLetter] = letterArray
        }
        words = outputDict
    }
}

extension UpdateLanguageLevelVocabularyVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return VocabularyHeaderTableViewCell.height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        noDataLabel.isHidden = !(sectionIndexes.count == 0 && !canContinueToNextPage)
        return sectionIndexes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return VocabularyItemTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let tempCell = tableView.dequeueReusableCell(withIdentifier: VocabularyHeaderTableViewCell.identifier),
           let cell = tempCell as? VocabularyHeaderTableViewCell {
            cell.setTitle(title: sectionIndexes[section])
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = words[sectionIndexes[section]] {
            return items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tempCell = tableView.dequeueReusableCell(withIdentifier: VocabularyItemTableViewCell.identifier),
           let cell = tempCell as? VocabularyItemTableViewCell,
           let items = words[sectionIndexes[indexPath.section]] {
            cell.setUp(word: items[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath

        if canContinueToNextPage,
           indexPath.section == words.count - 1 {
            loadData(page: page + 1)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let items = words[sectionIndexes[indexPath.section]] {
            if let urlString = items[indexPath.row].url,
               let url = URL(string: urlString) {
                openWebBrowser?(url)
            }
        }
    }
}
