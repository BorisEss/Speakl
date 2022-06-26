//
//  UpdateLanguageLevelViewController.swift
//  stori
//
//  Created by Alex on 30.04.2021.
//

import UIKit
import TableFlip

class UpdateLanguageLevelViewController: UIViewController {
    
    var language: Language?
    
    var levels: [LanguageLevel] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "edit_learning_level_title".localized
        
        setUpTableView()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if !levels.isEmpty { checkItem() }
    }
    
    private func setUpTableView() {
        tableView.register(UpdateLevelTableViewCell.nib(),
                           forCellReuseIdentifier: UpdateLevelTableViewCell.identifier)
    }
    
    private func loadData() {
        if let language = language {
            progressActivityIndicator.startAnimating()
            LanguageService().getLanguageLevels(language: language)
                .ensure {
                    self.progressActivityIndicator.stopAnimating()
                }
                .done { levels in
                    self.levels = levels
                    self.noDataLabel.isHidden = !levels.isEmpty
                    self.tableView.reloadData()
                    self.tableView.animate(animation: TableViewAnimation.Cell.right(duration: 0.8))
                    self.checkItem()
                }
                .catch { error in
                    error.parse()
                    self.noDataLabel.isHidden = false
                }
        } else {
            noDataLabel.isHidden = false
        }
    }
    
    private func checkItem() {
        if let selectedLanguage = language,
           let currentLanguage = Storage.shared.currentUser?.learningLanguage,
           selectedLanguage == currentLanguage,
           let selectedLevel = Storage.shared.currentUser?.learningLanguageLevel,
           let index = levels.firstIndex(where: { $0 == selectedLevel }) {
            self.tableView.selectRow(at: IndexPath(row: index, section: 0),
                                     animated: false,
                                     scrollPosition: .none)
        }
    }
}

extension UpdateLanguageLevelViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UpdateLevelTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mainCell = tableView.dequeueReusableCell(withIdentifier: UpdateLevelTableViewCell.identifier)
        if let cell = mainCell as? UpdateLevelTableViewCell {
            cell.setLanguageLevel(level: levels[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let cell = tableView.cellForRow(at: indexPath),
           cell.isSelected {
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Vibration().light()
        let level = levels[indexPath.row]
        guard let language = language else { return }
        UserClient.updateLanguageLevel(language: language, level: level)
            .ensure {
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
}
