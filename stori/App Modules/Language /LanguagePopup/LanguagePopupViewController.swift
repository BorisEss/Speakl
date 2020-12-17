//
//  LanguagePopupViewController.swift
//  stori
//
//  Created by Alex on 01.12.2020.
//

import UIKit

class LanguagePopupViewController: UIViewController {
    
    var languages: [Language]?
    var selectedLanguage: Language?
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
            tableViewHeightConstraint.constant = LanguageTableViewCell.height * CGFloat(count)
            tableView.isScrollEnabled = tableViewHeightConstraint.constant > 450
            if let selectedLanguage = selectedLanguage,
               let itemPlace = languages?.firstIndex(of: selectedLanguage) {
                tableView.selectRow(at: IndexPath(row: itemPlace, section: 0), animated: true, scrollPosition: .none)
            }
        }
    }
}

extension LanguagePopupViewController: UITableViewDelegate, UITableViewDataSource {
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
            cell.setUp(language: languages[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let language = languages?[indexPath.row] {
            selectedLanguage = language
            completion?(language)
            dismiss(animated: true, completion: nil)
        }
    }
}
