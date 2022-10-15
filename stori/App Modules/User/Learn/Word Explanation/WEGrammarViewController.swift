//
//  WEGrammarViewController.swift
//  stori
//
//  Created by Alex on 08.06.2022.
//

import UIKit

class WEGrammarViewController: UIViewController {
    
    private lazy var conjugationTableView: GeneralTableView? = nil

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuCollectionView: UICollectionView!
    
    @IBOutlet weak var contentStackView: UIStackView!
    
    @IBOutlet weak var infinitiveWordLabel: UILabel!
    
    @IBOutlet weak var nativeLanguageLabel: UILabel!
    @IBOutlet weak var nativeLanguageSwitch: UISwitch!
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var wordLevelLabel: UILabel!
    
    @IBOutlet weak var levelTitleLabel: UILabel!
    @IBOutlet weak var levelDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.isHidden = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.setUpLangFields()
            self.menuCollectionView.selectItem(at: IndexPath(item: 0, section: 0),
                                          animated: true,
                                          scrollPosition: .centeredHorizontally)
        }
    }
    
    private func setUpLangFields() {
        infinitiveWordLabel.text = "marcher"
        nativeLanguageLabel.text = "English"
        nativeLanguageSwitch.isOn = false
        wordLabel.text = "marché"
        wordLevelLabel.text = "A1 – le passé composé"
        levelTitleLabel.text = "A1 – le passé composé"
        levelDescriptionLabel.text = "Sed ut consequat maecenas enim, integer. Amet, amet massa mollis elementum bibendum sit feugiat sem. Egestas habitant adipiscing fames eu aenean. Nisi non velit."
        setUpConjugationTable()
    }
    
    private func setUpTranslateFields() {
        infinitiveWordLabel.text = "walk"
        nativeLanguageLabel.text = "English"
        nativeLanguageSwitch.isOn = true
        wordLabel.text = "walked"
        wordLevelLabel.text = "A1 – the past tense"
        levelTitleLabel.text = "A1 – the past tense"
        levelDescriptionLabel.text = "Sed ut consequat maecenas enim, integer. Amet, amet massa mollis elementum bibendum sit feugiat sem. Egestas habitant adipiscing fames eu aenean. Nisi non velit."
        setUpConjugationTable()
    }
    
    private func setUpConjugationTable() {
        if let conjugationTableView = conjugationTableView {
            contentStackView.removeArrangedSubview(conjugationTableView)
        }
        if let url = Bundle.main.url(forResource: nativeLanguageSwitch.isOn ? "conjugation_en" : "conjugation_fr", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(TableData.self, from: data)
                let table = GeneralTableView(width: contentStackView.bounds.width,
                                             data: jsonData,
                                             textAlignment: .left)
                table.heightAnchor.constraint(equalToConstant: table.tableHeight).isActive = true
                table.didSelectItem = { item in
//                    Toast.success(item)
                }
                contentStackView.insertArrangedSubview(table, at: contentStackView.arrangedSubviews.count - 1)
                conjugationTableView = table
            } catch {
                print("error:\(error)")
            }
        }
    }
    
    @IBAction func nativeLanguageSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            setUpTranslateFields()
        } else {
            setUpLangFields()
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addToFavoritesButtonPressed(_ sender: UIButton) {
        if sender.currentTitle == "Add to ⭐️" {
            sender.setTitle("Remove ⭐️", for: .normal)
        } else {
            sender.setTitle("Add to ⭐️", for: .normal)
        }
    }
    
}

extension WEGrammarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt
                        indexPath: IndexPath) -> UICollectionViewCell {
        let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WEGrammarMenuCollectionViewCell",
                                                          for: indexPath)
        
        if let cell = mainCell as? WEGrammarMenuCollectionViewCell {
            switch indexPath.item {
            case 0: cell.titleLabel.text = "Conjugaison"
            case 1: cell.titleLabel.text = "Règles"
            case 2: cell.titleLabel.text = "Cas particuliers"
            default: cell.titleLabel.text = nil
            }
            return cell
        }
        return mainCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        print(indexPath.item)
        conjugationTableView?.isHidden = indexPath.item != 0
        // swiftlint:disable line_length
        switch indexPath.item {
        case 0: levelDescriptionLabel.text = "Sed ut consequat maecenas enim, integer. Amet, amet massa mollis elementum bibendum sit feugiat sem. Egestas habitant adipiscing fames eu aenean. Nisi non velit."
        case 1: levelDescriptionLabel.text = "Consequat et, nunc, quis arcu. Egestas diam dictum viverra sed id justo. Ullamcorper felis dui scelerisque viverra. Faucibus id porta ac dictum tristique sodales volutpat duis habitant."
        case 2: levelDescriptionLabel.text = "Magna tristique scelerisque purus, ullamcorper. Molestie tortor id eget quis mattis commodo nulla. Diam lorem et, fusce diam. Risus nunc cum in vitae nec quis pretium eu. Facilisi sed lectus in vitae et lectus. Augue sed iaculis massa consequat scelerisque venenatis a lobortis.\n\nErat mus vel posuere enim fermentum. Enim quis id urna aliquam adipiscing amet sodales morbi scelerisque. Nunc, sit lacinia in maecenas nibh nunc. Nibh est sed in sem at volutpat. Egestas scelerisque scelerisque duis cras blandit aenean id urna."
        default: break
        }
        // swiftlint:enable line_length
    }
    
}
