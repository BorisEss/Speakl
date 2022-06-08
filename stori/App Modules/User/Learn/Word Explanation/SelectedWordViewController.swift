//
//  SelectedWordViewController.swift
//  stori
//
//  Created by Alex on 03.01.2022.
//

import UIKit

class SelectedWordViewController: UIViewController {

    private var previousIndexPath: IndexPath = IndexPath()
    
    @IBOutlet weak var menuCollectionView: UICollectionView!
    
    @IBOutlet weak var dictionaryView: UIView!
    @IBOutlet weak var pronunciationView: UIView!
    @IBOutlet weak var examplesView: UIView!
    @IBOutlet weak var expressionsView: UIView!
    
    @IBOutlet weak var addToFavoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        previousIndexPath = IndexPath(item: 0, section: 0)
        
        menuCollectionView.selectItem(at: previousIndexPath,
                                      animated: false,
                                      scrollPosition: [])

        dictionaryView.isHidden = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let nextVc = segue.destination as? WEPronunciationViewController {
            nextVc.delegate = self
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

extension SelectedWordViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedWordMenuCollectionViewCell",
                                                          for: indexPath)
        if let cell = mainCell as? SelectedWordMenuCollectionViewCell {
            switch indexPath.item {
            case 0: cell.titleLabel.text = "Dictionary"
            case 1: cell.titleLabel.text = "Pronunciation"
            case 2: cell.titleLabel.text = "Examples"
            case 3: cell.titleLabel.text = "Expressions"
            default: break
            }
            return cell
        }
        return mainCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dictionaryView.isHidden = true
        pronunciationView.isHidden = true
        examplesView.isHidden = true
        expressionsView.isHidden = true
        switch indexPath.item {
        case 0: dictionaryView.isHidden = false
        case 1: pronunciationView.isHidden = false
        case 2: examplesView.isHidden = false
        case 3: expressionsView.isHidden = false
        default: break
        }
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}

extension SelectedWordViewController: WEPronunciationViewControllerDelegate {
    func didTapInfo() {
        performSegue(withIdentifier: "showExplanation", sender: nil)
    }
}
