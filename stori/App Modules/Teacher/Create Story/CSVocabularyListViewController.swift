//
//  CSVocabularyListViewController.swift
//  stori
//
//  Created by Alex on 30.01.2021.
//

import UIKit

class CSVocabularyListViewController: UIViewController {

    private let showWebBrowserSegue = "showWebBrowser"
    
    var vocabularyId: Int?
    
    var languageLevel: LanguageLevel? = CreateStoryObject.shared?.chapter?.languageLevel
        
    private var words: [String: [VocabularyWord]] = [:] {
        didSet {
            sectionIndexes = [String](words.keys)
            sectionIndexes.sort(by: { $0 < $1 })
        }
    }
    private var sectionIndexes: [String] = []
    private var wordsCount: Int = 0 {
        didSet {
            setUpLanguage()
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
    
    private var wordGrammarUrl: URL?
    
    private var isSearchActive: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var progressActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLanguage()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appendWords(newWords: nil)
        loadData(page: page)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVc = segue.destination as? WebBrowserViewController {
            if let languageLevel = languageLevel,
               let shortcut = languageLevel.shortcut {
                nextVc.title = "\(shortcut) - \("cs_text_grammar_guide".localized)"
            } else {
                nextVc.title = "cs_text_grammar_guide".localized
            }
            nextVc.url = wordGrammarUrl
            nextVc.noDataTitle = "cs_text_grammar_word_missing".localized
            wordGrammarUrl = nil
        }
    }
    
    @IBAction func searchDidBegin(_ sender: Any) {
        isSearchActive = true
    }
    
    @IBAction func searchDidEnd(_ sender: Any) {
        isSearchActive = !(searchTextField.text ?? "").isEmpty
        if !isSearchActive {
            words = [:]
            loadData(page: 1)
        }
    }
    
    private func setUpLanguage() {
        noDataLabel.text = "cs_vocabulary_no_data".localized
        searchTextField.placeholder = "cs_vocabulary_search".localized
        guard let languageLevel = languageLevel,
              let shortcut = languageLevel.shortcut else {
            title = "cs_vocabulary_list".localized
            return
        }
        let wordText = wordsCount == 1 ? "cs_vocabulary_word".localized : "cs_vocabulary_words".localized
        navigationItem.setTitleAndSubtitle(title: "\(shortcut) - \("cs_vocabulary_list".localized)",
                                           subtitle: "\(wordsCount) \(wordText)")
    }
    
    private func setUpTableView() {
        tableView.register(VocabularyItemTableViewCell.nib(),
                           forCellReuseIdentifier: VocabularyItemTableViewCell.identifier)
        tableView.register(VocabularyHeaderTableViewCell.nib(),
                           forCellReuseIdentifier: VocabularyHeaderTableViewCell.identifier)
    }
    
    private func loadData(page: Int) {
        guard let vocabularyId = vocabularyId else {
            self.canContinueToNextPage = false
            self.searchView.isHidden = true
            self.progressActivityIndicator.stopAnimating()
            self.tableView.reloadData()
            return
        }
        if isSearchActive,
           let searchText = searchTextField.text {
            CSPresenter.vocabulary.searchWords(vocabularyId: vocabularyId,
                                               page: page,
                                               search: searchText)
                .done { (response) in
                    self.canContinueToNextPage = false
                    self.canContinueToNextPage = response.next != nil
                    self.wordsCount = response.count
                    self.appendWords(newWords: response.results)
                }
                .ensure {
                    self.progressActivityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
                .cauterize()
        } else {
            CSPresenter.vocabulary.getWords(vocabularyId: vocabularyId,
                                            page: page)
                .done { (response) in
                    self.canContinueToNextPage = false
                    self.canContinueToNextPage = response.next != nil
                    self.wordsCount = response.count
                    self.appendWords(newWords: response.results)
                }
                .ensure {
                    self.progressActivityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
                .cauterize()
        }
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

extension CSVocabularyListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return VocabularyHeaderTableViewCell.height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearchActive {
            noDataLabel.text = "common_no_results_message".localized
            noDataLabel.isHidden = sectionIndexes.count != 0
        } else {
            noDataLabel.text = "cs_vocabulary_no_data".localized
            noDataLabel.isHidden = !(sectionIndexes.count == 0 && !canContinueToNextPage)
            searchView.isHidden = sectionIndexes.count == 0 && !canContinueToNextPage
        }
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
            wordGrammarUrl = URL(string: items[indexPath.row].url ?? "")
            performSegue(withIdentifier: showWebBrowserSegue, sender: nil)
        }
        
    }
}

extension CSVocabularyListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        page = 1
        loadData(page: page)
    }
}
