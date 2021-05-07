//
//  UpdateNativeLanguageViewController.swift
//  stori
//
//  Created by Alex on 29.04.2021.
//

import UIKit
import TableFlip

class UpdateLanguageViewController: UIViewController {
    
    enum UpdateLanguageType {
        case native
        case learning
    }
    
    var type: UpdateLanguageType = .native
    
    var items: [Language] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLanguage()
        setUpTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVc = segue.destination as? UpdateLanguageLevelViewController {
            if let index = tableView.indexPathForSelectedRow {
                nextVc.language = items[index.row]
            }
        }
    }
    
    private func setUpLanguage() {
        switch type {
        case .native:
            title = "edit_native_language_title".localized
        case .learning:
            title = "edit_learning_language_title".localized
        }
    }
    
    private func setUpTableView() {
        tableView.register(CSItemTableViewCell.nib(),
                           forCellReuseIdentifier: CSItemTableViewCell.identifier)
        var selectedLanguage: Language?
        switch type {
        case .native:
            items = Storage.shared.languages
            selectedLanguage = Storage.shared.currentLanguage
        case .learning:
            items = Storage.shared.currentUser?.learningLanguages ?? []
            selectedLanguage = Storage.shared.currentUser?.learningLanguage
        }
        tableView.reloadData()
        tableView.animate(animation: TableViewAnimation.Cell.right(duration: 0.8))
        if let selectedLanguage = selectedLanguage,
           let index = items.firstIndex(of: selectedLanguage) {
            tableView.selectRow(at: IndexPath(row: index, section: 0),
                                animated: false,
                                scrollPosition: .none)
        }
    }
}

extension UpdateLanguageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CSItemTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mainCell = tableView.dequeueReusableCell(withIdentifier: CSItemTableViewCell.identifier)
        if let cell = mainCell as? CSItemTableViewCell {
            cell.setLanguage(language: items[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let cell = tableView.cellForRow(at: indexPath),
           cell.isSelected,
           type == .native {
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Vibration().light()
        switch type {
        case .native:
            showWarningWhenChangingLanguage(newLanguage: items[indexPath.row])
        case .learning:
            performSegue(withIdentifier: "showLanguageLevels", sender: nil)
        }
    }
    
    private func showWarningWhenChangingLanguage(newLanguage: Language) {
        let alert = UIAlertController(title: "edit_native_language_confirmation_title".localized,
                                      message: "edit_native_language_confirmation_message".localized,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "edit_native_language_confirm".localized,
                                      style: .default, handler: { _ in
            UserClient.updateUserNativeLanguage(language: newLanguage)
                .done { _ in
                    Storage.shared.currentLanguage = newLanguage
                    Router.load()
                }
                .catch { error in
                    error.parse()
                }
        }))
        alert.addAction(UIAlertAction(title: "common_cancel_title".localized,
                                      style: .cancel, handler: { _ in
            if let selectedLanguage = Storage.shared.currentLanguage,
               let index = self.items.firstIndex(of: selectedLanguage) {
                self.tableView.selectRow(at: IndexPath(row: index, section: 0),
                                         animated: true,
                                         scrollPosition: .none)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
