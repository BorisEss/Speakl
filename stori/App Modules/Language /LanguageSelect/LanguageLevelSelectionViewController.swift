//
//  LanguageLevelSelectionViewController.swift
//  stori
//
//  Created by Alex on 09.12.2020.
//

import UIKit
import TableFlip

class LanguageLevelSelectionViewController: UIViewController {

    // MARK: - Internal proprietes
    var nativeLanguage: Language?
    var learningLanguage: Language?
    var levels: [LanguageLevel] = [] {
        didSet {
            tableView.reloadData()
            tableView.animate(animation: TableViewAnimation.Cell.fade(duration: 0.6))
        }
    }
    var selectedLevel: LanguageLevel?

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nextButton: RegularButton!
    @IBOutlet weak var nextButtonProgressActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        setUpLanguage()

        if let language = learningLanguage {
            LanguageService().getLanguageLevels(language: language)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC = segue.destination as? LanguageInterestsSelectionViewController {
            nextVC.nativeLanguage = nativeLanguage
            nextVC.learningLanguage = learningLanguage
            nextVC.selectedLevel = selectedLevel
        }
    }
    
    // MARK: - Button Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func nextButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goNext", sender: nil)
    }
    
    // MARK: - UI Setup
    func setUpView() {
        setUpTableView()
    }
    func setUpTableView() {
        tableView.register(LanguageLevelTableViewCell.nib(),
                           forCellReuseIdentifier: LanguageLevelTableViewCell.identifier)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
    }
    func setUpLanguage() {
        if let lang = learningLanguage {
            titleLabel.text = String(format: "select_lang_level_vc_page_title".localized, lang.name)
        }
        subtitleLabel.text = "select_lang_level_vc_page_subtitle".localized
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
