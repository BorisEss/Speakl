//
//  LanguageLevelSelectionViewController.swift
//  stori
//
//  Created by Alex on 09.12.2020.
//

import UIKit

class LanguageLevelSelectionViewController: UIViewController {

    // MARK: - Internal proprietes
    var shouldGoBack: Bool = false
    var levels: [LanguageLevel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var selectedLevel: LanguageLevel?

    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftSpacingTitleLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var testQuestionLabel: UILabel!
    @IBOutlet weak var testButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nextButton: RegularButton!
    @IBOutlet weak var nextButtonProgressActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        setUpLanguage()
        
        if let user = Storage.shared.currentUser,
           let langId = user.langToLearn,
           let language = Storage.shared.languageBy(id: langId) {
            LanguagePresenter().getLanguageLevels(language: language)
                .done { (levels) in
                    self.levels = levels
                }
                .ensure {
                    self.progressActivityIndicator.stopAnimating()
                }
                .cauterize()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Button Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func beginTestButtonPressed(_ sender: Any) {
        
    }
    @IBAction func nextButtonPressed(_ sender: Any) {
        if let level = selectedLevel {
            nextButton.isHidden = true
            tableView.isUserInteractionEnabled = false
            nextButtonProgressActivityIndicator.startAnimating()
            LanguagePresenter().updateLearningLanguageLevel(level: level) { (isSuccess) in
                self.nextButton.isHidden = false
                self.tableView.isUserInteractionEnabled = true
                self.nextButtonProgressActivityIndicator.stopAnimating()
                if isSuccess {
                    Router.load()
                }
            }
        }
    }
    
    // MARK: - UI Setup
    func setUpView() {
        backButton.isHidden = !shouldGoBack
        leftSpacingTitleLabelConstraint.constant = shouldGoBack ? 33 : -7
        setUpTableView()
    }
    func setUpTableView() {
        tableView.register(LanguageLevelTableViewCell.nib(),
                           forCellReuseIdentifier: LanguageLevelTableViewCell.identifier)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
    }
    func setUpLanguage() {
        if let langId = Storage.shared.currentUser?.langToLearn,
           let lang = Storage.shared.languageBy(id: langId) {
            titleLabel.text = String(format: "select_lang_level_vc_page_title".localized, lang.name)
        }
        subtitleLabel.text = "select_lang_level_vc_page_subtitle".localized
        testQuestionLabel.text = "select_lang_level_vc_page_test_question".localized
        testButton.setTitle("select_lang_level_vc_page_test_button".localized, for: .normal)
        nextButton.setTitle("common_next_title".localized, for: .normal)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LanguageLevelSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LanguageLevelTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let mainCell = tableView.dequeueReusableCell(withIdentifier: LanguageLevelTableViewCell.identifier),
           let cell = mainCell as? LanguageLevelTableViewCell {
            cell.setUp(level: levels[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLevel = levels[indexPath.row]
        nextButton.isEnabled = true
    }
}
