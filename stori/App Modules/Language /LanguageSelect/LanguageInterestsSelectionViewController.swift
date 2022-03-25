//
//  LanguageInterestsSelectionViewController.swift
//  stori
//
//  Created by Alex on 14.12.2020.
//

import UIKit
import TableFlip
import SPPermissions

class LanguageInterestsSelectionViewController: UIViewController {

    // MARK: - Internal proprietes
    var nativeLanguage: Language?
    var learningLanguage: Language?
    var selectedLevel: LanguageLevel?
    var interests: [Interest] = [] {
        didSet {
            tableView.reloadData()
            tableView.animate(animation: TableViewAnimation.Cell.fade(duration: 0.6))
        }
    }
    var dataLoaded: Bool = false
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var progressActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: RegularButton!
    @IBOutlet weak var nextProgressActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpLanguage()
        
        guard let learningLanguage = learningLanguage else { return }
        LanguageService().getInterests(for: learningLanguage)
            .ensure {
                self.dataLoaded = true
                self.progressActivityIndicator.stopAnimating()
            }
            .done { (interests) in
                self.interests = interests
                if self.interests.isEmpty, self.dataLoaded {
                    self.noDataLabel.isHidden = false
                } else {
                    self.noDataLabel.isHidden = true
                }
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
        var selectedInterests: [Interest] = []
        if let indexes = tableView.indexPathsForSelectedRows {
            for index in indexes {
                selectedInterests.append(interests[index.section])
            }
        }
        tableView.isUserInteractionEnabled = false
        nextProgressActivityIndicator.startAnimating()
        nextButton.isHidden = true
        LanguageService().updateLanguageDetails(nativeLanguage: nativeLanguage,
                                                  learningLanguage: learningLanguage,
                                                  learningLanguageLevel: selectedLevel,
                                                  interests: selectedInterests) { (isSuccess) in
            self.tableView.isUserInteractionEnabled = true
            self.nextProgressActivityIndicator.stopAnimating()
            self.nextButton.isHidden = false
            if isSuccess {
                if SPPermissions.Permission.notification.notDetermined {
                    let permissions: [SPPermissions.Permission] = [.notification]
                    let controller = SPPermissions.list(permissions)
                    controller.showCloseButton = true
                    controller.allowSwipeDismiss = true
                    controller.delegate = self
                    controller.present(on: self)
                } else {
                    Router.load()
                }
            }
        }
    }
    
    // MARK: - UI Setup
    private func setUpView() {
        setUpTableView()
    }
    
    private func setUpTableView() {
        tableView.register(InterestTableViewCell.nib(),
                           forCellReuseIdentifier: InterestTableViewCell.identifier)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
    }
    
    private func setUpLanguage() {
        titleLabel.text = "select_interests_vc_page_title".localized
        subtitleLabel.text = "select_interests_vc_page_subtitle".localized
        nextButton.setTitle("select_interests_vc_next_button".localized, for: .normal)
        noDataLabel.text = "common_nothing_to_show".localized
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LanguageInterestsSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return interests.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let mainCell = tableView.dequeueReusableCell(withIdentifier: InterestTableViewCell.identifier),
           let cell = mainCell as? InterestTableViewCell {
            cell.setUp(interest: interests[indexPath.section])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if (tableView.indexPathsForSelectedRows ?? []).contains(indexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            return nil
        } else {
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkSelectedItems()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        checkSelectedItems()
    }
    
    private func checkSelectedItems() {
        nextButton.isEnabled = !(tableView.indexPathsForSelectedRows?.isEmpty ?? true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return InterestTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
}

// MARK: - SPPermissionsDelegate
extension LanguageInterestsSelectionViewController: SPPermissionsDelegate {
    func didHidePermissions(_ permissions: [SPPermissions.Permission]) {
        Router.load()
    }
    func didDeniedPermission(_ permission: SPPermissions.Permission) {
        Router.load()
    }
    func didAllowPermission(_ permission: SPPermissions.Permission) {
        Router.load()
    }
}
