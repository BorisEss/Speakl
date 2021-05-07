//
//  UpdateLanguageLevelDetailsViewController.swift
//  stori
//
//  Created by Alex on 30.04.2021.
//

import UIKit

class UpdateLanguageLevelDetailsViewController: UIViewController {
    
    enum DetailsType {
        case vocabulary
        case grammar
    }
    
    var language: Language?
    var level: LanguageLevel?

    var type: DetailsType = .vocabulary {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.vocabularyUnderlineView.alpha = self.type == .grammar ? 0 : 1
                self.grammarUnderlineView.alpha = self.type == .grammar ? 1 : 0
                self.view.layoutIfNeeded()
            }
            loadNavbarTitle()
        }
    }
    var wordCount: Int? {
        didSet {
            loadNavbarTitle()
        }
    }
    
    private var wordGrammarUrl: URL?
    
    @IBOutlet weak var vocabularyUnderlineView: UIView!
    @IBOutlet weak var grammarUnderlineView: UIView!
    
    @IBOutlet weak var vocabularyContainerView: UIView!
    @IBOutlet weak var grammarContainerView: UIView!
    
    @IBOutlet weak var saveButton: RegularButton!
    @IBOutlet weak var progressActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadNavbarTitle()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVc = segue.destination as? UpdateLanguageLevelGrammarViewController {
            nextVc.language = language
            nextVc.level = level
        }
        
        if let nextVc = segue.destination as? UpdateLanguageLevelVocabularyVC {
            nextVc.language = language
            nextVc.level = level
            nextVc.wordCountUpdated = { [weak self] value in
                self?.wordCount = value
            }
            nextVc.openWebBrowser = { [weak self] url in
                self?.wordGrammarUrl = url
                self?.performSegue(withIdentifier: "showWebBrowser", sender: nil)
            }
        }
        
        if let nextVc = segue.destination as? WebBrowserViewController {
            if let languageLevel = level,
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
    
    @IBAction func vocabularyButtonPressed(_ sender: Any) {
        type = .vocabulary
        Vibration().light()
        if vocabularyContainerView.isHidden {
            UIView.transition(from: grammarContainerView,
                              to: vocabularyContainerView,
                              duration: 0.3,
                              options: [.curveEaseInOut, .layoutSubviews, .showHideTransitionViews], completion: nil)
        }
    }
    
    @IBAction func grammarButtonPressed(_ sender: Any) {
        type = .grammar
        Vibration().light()
        if grammarContainerView.isHidden {
            UIView.transition(from: vocabularyContainerView,
                              to: grammarContainerView,
                              duration: 0.3,
                              options: [.curveEaseInOut, .layoutSubviews, .showHideTransitionViews], completion: nil)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let level = level,
              let language = language else { return }
        saveButton.isHidden = true
        progressActivityIndicator.startAnimating()
        UserClient.updateLanguageLevel(language: language, level: level)
            .ensure {
                self.saveButton.isHidden = false
                self.progressActivityIndicator.stopAnimating()
            }
            .done { _ in
                Toast.success("edit_learning_level_success".localized)
                self.navigationController?.popToRootViewController(animated: true)
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }
            .catch { error in
                error.parse()
            }
    }
    
    private func loadNavbarTitle() {
        guard let level = level,
              let levelShortcut = level.shortcut else { return }
        switch type {
        case .vocabulary:
            let titleString = String(format: "%@ - %@",
                                     levelShortcut,
                                     "cs_vocabulary_list".localized)
            var subtitleString = ""
            if let wordCount = wordCount {
                let wordText = wordCount == 1 ? "cs_vocabulary_word".localized : "cs_vocabulary_words".localized
                subtitleString = String(format: "%d %@",
                                        wordCount,
                                        wordText)
            }
            navigationItem.setTitleAndSubtitle(title: titleString,
                                               subtitle: subtitleString)
        case .grammar:
            let titleString = String(format: "%@ - %@",
                                     levelShortcut,
                                     "cs_text_grammar_guide".localized)
            navigationItem.setTitleAndSubtitle(title: titleString,
                                               subtitle: "")
        }
    }
}
