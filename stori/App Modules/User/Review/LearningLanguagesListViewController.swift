//
//  LearningLanguagesListViewController.swift
//  stori
//
//  Created by Alex on 26.04.2022.
//

import UIKit

class LearningLanguagesListViewController: UIViewController {

    // MARK: - Variables
    var languages: [Language]? = Storage.shared.currentUser?.learningLanguages
    var selectedLanguage: Language? = Storage.shared.currentUser?.learningLanguage
    var completion: ((_ language: Language) -> Void)?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }

    private func setUpTableView() {
        tableView.register(LanguageTableViewCell.nib(),
                           forCellReuseIdentifier: LanguageTableViewCell.identifier)
        if let count = languages?.count {
            tableViewHeightConstraint.constant = (min(404, LanguageTableViewCell.height * CGFloat(count)) + 64)
            tableView.isScrollEnabled = tableViewHeightConstraint.constant > 403
            if let selectedLanguage = selectedLanguage,
               let itemPlace = languages?.firstIndex(of: selectedLanguage) {
                tableView.selectRow(at: IndexPath(row: itemPlace, section: 0), animated: true, scrollPosition: .none)
            }
        }
    }
}

extension LearningLanguagesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LanguageTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let mainCell = tableView.dequeueReusableCell(withIdentifier: LanguageTableViewCell.identifier),
           let cell = mainCell as? LanguageTableViewCell,
           let languages = languages {
            cell.isBlackStyle = true
            cell.setUp(language: languages[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard languages?[indexPath.row] != selectedLanguage else { return }
        if let language = languages?[indexPath.row] {
            selectedLanguage = language
            print(language.name)
//            completion?(language)
//            dismiss(animated: true, completion: nil)
        }
    }
}
