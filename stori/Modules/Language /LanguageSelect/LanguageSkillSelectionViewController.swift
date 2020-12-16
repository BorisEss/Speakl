//
//  LanguageSkillSelectionViewController.swift
//  stori
//
//  Created by Alex on 08.12.2020.
//

import UIKit
import PromiseKit

class LanguageSkillSelectionViewController: UIViewController {

    // MARK: - Internal proprietes
    var skills: [Skill] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var shouldGoBack: Bool = false
    
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var leftTitleLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: RegularButton!
    @IBOutlet weak var savingProgressActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        setUpLanguage()
        
        LanguagePresenter().getSkills()
            .done { (skills) in
                self.skills = skills
            }
            .ensure {
                self.progressActivityIndicator.stopAnimating()
            }
            .cauterize()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Button Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        var selectedSkills: [Skill] = []
        if let indexes = tableView.indexPathsForSelectedRows {
            for index in indexes {
                selectedSkills.append(skills[index.row])
            }
        }
        tableView.isUserInteractionEnabled = false
        savingProgressActivityIndicator.startAnimating()
        nextButton.isHidden = true
        LanguagePresenter().updateSkills(skills: selectedSkills) { (isSuccess) in
            self.tableView.isUserInteractionEnabled = true
            self.savingProgressActivityIndicator.stopAnimating()
            self.nextButton.isHidden = false
            if isSuccess {
                Router.load()
            }
        }
    }
    
    // MARK: - UI Setup
    private func setUpView() {
        leftTitleLabelConstraint.constant = shouldGoBack ? 33 : -7
        backButton.isHidden = !shouldGoBack
        setUpTableView()
    }
    private func setUpTableView() {
        tableView.register(SkillTableViewCell.nib(),
                           forCellReuseIdentifier: SkillTableViewCell.identifier)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
        tableView.allowsMultipleSelection = true
    }
    private func setUpLanguage() {
        titleLabel.text = "select_lang_skills_vc_page_title".localized
        nextButton.setTitle("common_next_title".localized, for: .normal)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LanguageSkillSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SkillTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skills.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let mainCell = tableView.dequeueReusableCell(withIdentifier: SkillTableViewCell.identifier),
           let cell = mainCell as? SkillTableViewCell {
            cell.setUp(skill: skills[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkSelectedCells()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        checkSelectedCells()
    }
    
    private func checkSelectedCells() {
        nextButton.isEnabled = !(tableView.indexPathsForSelectedRows?.isEmpty ?? true)
    }
}
