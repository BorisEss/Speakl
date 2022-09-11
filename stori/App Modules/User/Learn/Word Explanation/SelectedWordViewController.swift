//
//  SelectedWordViewController.swift
//  stori
//
//  Created by Alex on 03.01.2022.
//

import UIKit

protocol UICustomScrollDelegate: AnyObject {
    func scrollViewDidScroll(_ scrollView: UIScrollView)
}

class SelectedWordViewController: UIViewController {

    // MARK: Scroll View Animation
    var previousOffset: CGPoint?
    var viewHeight: CGFloat = 50
    @IBOutlet weak var menuViewHeight: NSLayoutConstraint!
    
    private var previousIndexPath: IndexPath = IndexPath()
    
    private var dictionaryVc: WEDictionaryViewController?
    private var pronunciationVc: WEPronunciationViewController?
    private var examplesVc: WEExamplesViewController?
    private var expressionsVc: WEExpressionsViewController?
    
    @IBOutlet weak var menuView: UIView!
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
        dictionaryVc?.scrollDelegate = self
        
        previousOffset = .zero
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let nextVc = segue.destination as? WEDictionaryViewController {
            dictionaryVc = nextVc
        }
        if let nextVc = segue.destination as? WEPronunciationViewController {
            nextVc.delegate = self
            pronunciationVc = nextVc
        }
        if let nextVc = segue.destination as? WEExamplesViewController {
            examplesVc = nextVc
        }
        if let nextVc = segue.destination as? WEExpressionsViewController {
            expressionsVc = nextVc
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
        case 0:
            dictionaryView.isHidden = false
            dictionaryVc?.scrollDelegate = self
        case 1:
            pronunciationView.isHidden = false
            pronunciationVc?.scrollDelegate = self
        case 2:
            examplesView.isHidden = false
            examplesVc?.scrollDelegate = self
        case 3:
            expressionsView.isHidden = false
            expressionsVc?.scrollDelegate = self
        default: break
        }
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        collectionView.collectionViewLayout.invalidateLayout()
        view.layoutIfNeeded()
    }
    
}

extension SelectedWordViewController: WEPronunciationViewControllerDelegate {
    func didTapInfo() {
        performSegue(withIdentifier: "showExplanation", sender: nil)
    }
}

extension SelectedWordViewController: UICustomScrollDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let menuViewHeight = menuViewHeight else { return }
                
        let currentOffset = scrollView.contentOffset
                
        if let startOffset = previousOffset {
            // Get the distance scrolled
            let delta = abs((startOffset.y - currentOffset.y))
                    
            if currentOffset.y > startOffset.y,
               currentOffset.y > .zero {
                // Scrolling down
                
                // Set the new height based on the amount scrolled
                var newHeight = menuViewHeight.constant - delta
                
                // Make sure we do not go below 0
                if newHeight < .zero {
                    newHeight = .zero
                }
                
                menuViewHeight.constant = newHeight
            } else if currentOffset.y < startOffset.y,
                      currentOffset.y <= viewHeight {
                // Scrolling up
                
                var newHeight = menuViewHeight.constant + delta
                
                // Make sure we do not go above the max height
                if newHeight > viewHeight {
                    newHeight = viewHeight
                }
                
                menuViewHeight.constant = newHeight
            }
            
            // Update the previous offset
            previousOffset = scrollView.contentOffset
            
            self.view.layoutIfNeeded()
        }
    }
}
