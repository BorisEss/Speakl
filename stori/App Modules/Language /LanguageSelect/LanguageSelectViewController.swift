//
//  LanguageSelectViewController.swift
//  stori
//
//  Created by Alex on 07.12.2020.
//

import UIKit

enum LanguageSelectionState {
    case native
    case learning
}

class LanguageSelectViewController: UIViewController {
    
    // MARK: - Internal proprietes
    let languages: [Language] = Storage.shared.languages
    var nativeLanguage: Language?
    var learningLanguage: Language?
    
    var shouldGoBack: Bool = false
    
    var state: LanguageSelectionState = .native {
        didSet {
            switch state {
            case .native: setUpNativeUI()
            case .learning: setUpLearningUI()
            }
        }
    }

    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: RegularButton!
    @IBOutlet weak var progressActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpLanguage()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Button Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        if shouldGoBack {
            navigationController?.popViewController(animated: true)
        } else if state == .learning {
            state = .native
            if let indexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: indexPath, animated: true)
            }
            if let nativeLang = nativeLanguage,
               let index = languages.firstIndex(of: nativeLang),
               let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)),
               let languageCell = cell as? LanguageTableViewCell {
                languageCell.enable()
            }
            nativeLanguage = nil
            learningLanguage = nil
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        switch state {
        case .native:
            state = .learning
        case .learning:
            if let native = nativeLanguage,
               let selected = learningLanguage {
                nextButton.isHidden = true
                tableView.isUserInteractionEnabled = false
                progressActivityIndicator.startAnimating()
                LanguagePresenter().updateLanguages(native: native,
                                                    learning: selected) { (isSuccess) in
                    self.nextButton.isHidden = false
                    self.tableView.isUserInteractionEnabled = true
                    self.progressActivityIndicator.stopAnimating()
                    if isSuccess {
                        Router.load()
                    }
                }
            }
        }
    }
    
    // MARK: - UI Setup
    private func setUpView() {
        setUpTableView()
        if let nativeLanguage = nativeLanguage,
           let index = languages.firstIndex(of: nativeLanguage) {
            tableView.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .none)
            state = .learning
        }
    }
    
    private func setUpTableView() {
        tableView.register(LanguageTableViewCell.nib(),
                           forCellReuseIdentifier: LanguageTableViewCell.identifier)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
    }
    
    private func setUpLanguage() {
        nextButton.setTitle("common_next_title".localized, for: .normal)
    }
    
    private func setUpNativeUI() {
        backButton.isHidden = !shouldGoBack
        titleLabel.text = "select_langs_vc_page_title_select_native_language".localized
        nextButton.isEnabled = false
    }
    
    private func setUpLearningUI() {
        backButton.isHidden = false
        titleLabel.text = "select_langs_vc_page_title_select_learn_language".localized
        if let nativeLang = nativeLanguage,
           let index = languages.firstIndex(of: nativeLang),
           let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)),
           let languageCell = cell as? LanguageTableViewCell {
            languageCell.disable()
        }
        nextButton.isEnabled = false
    }
    
    func fillWith(language: Language,
                  shouldGoBack: Bool? = nil) {
        nativeLanguage = language
        self.shouldGoBack = shouldGoBack ?? true
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LanguageSelectViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LanguageTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let mainCell = tableView.dequeueReusableCell(withIdentifier: LanguageTableViewCell.identifier),
           let cell = mainCell as? LanguageTableViewCell {
            cell.setUp(language: languages[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch state {
        case .native:
            nativeLanguage = languages[indexPath.row]
        case .learning:
            learningLanguage = languages[indexPath.row]
        }
        nextButton.isEnabled = true
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let cell = tableView.cellForRow(at: indexPath) as? LanguageTableViewCell {
            if cell.state != .disabled {
                return indexPath
            }
        }
        return nil
    }
}
