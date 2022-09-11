//
//  WEPronunciationViewController.swift
//  stori
//
//  Created by Alex on 04.01.2022.
//

import UIKit

protocol WEPronunciationViewControllerDelegate: AnyObject {
    func didTapInfo()
}

class WEPronunciationViewController: UIViewController {
    
    var audios: [String] = ["SPAIN", "LATAM"]
    var styles: [String] = ["LATAM", "SPAIN"]
    
    weak var delegate: WEPronunciationViewControllerDelegate?
    weak var scrollDelegate: UICustomScrollDelegate?

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var audiosCollectionView: UICollectionView!
    @IBOutlet weak var stylesCollectionView: UICollectionView!
    
    @IBOutlet weak var expression1ArrowIcon: UIImageView!
    @IBOutlet weak var expression1DefinitionView: UIStackView!
    
    @IBOutlet weak var expression2ArrowIcon: UIImageView!
    @IBOutlet weak var expression2DefinitionView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stylesCollectionView.selectItem(at: IndexPath(item: 0, section: 0),
                                      animated: false,
                                      scrollPosition: [])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        audiosCollectionView.centerContentHorizontalyByInsetIfNeeded(minimumInset: UIEdgeInsets.zero)
//        stylesCollectionView.centerContentHorizontalyByInsetIfNeeded(minimumInset: UIEdgeInsets.zero)
    }
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        delegate?.didTapInfo()
    }
    
    @IBAction func expression1ButtonPressed(_ sender: UIButton) {
        expression1DefinitionView.isHidden = !expression1DefinitionView.isHidden
        if expression1DefinitionView.isHidden {
            expression1ArrowIcon.image = UIImage(named: "tint_right_arrow")
        } else {
            expression1ArrowIcon.image = UIImage(named: "tint_bottom_arrow")
        }
    }
    
    @IBAction func expression2ButtonPressed(_ sender: UIButton) {
        expression2DefinitionView.isHidden = !expression2DefinitionView.isHidden
        if expression2DefinitionView.isHidden {
            expression2ArrowIcon.image = UIImage(named: "tint_right_arrow")
        } else {
            expression2ArrowIcon.image = UIImage(named: "tint_bottom_arrow")
        }
    }
    
}

extension WEPronunciationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView == audiosCollectionView {
            return audios.count
        } else if collectionView == stylesCollectionView {
            return styles.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == audiosCollectionView {
            return getAudioCell(for: indexPath)
        } else if collectionView == stylesCollectionView {
            return getStyleCell(for: indexPath)
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        if collectionView == stylesCollectionView {
            collectionView.collectionViewLayout.invalidateLayout()
        } else if collectionView == audiosCollectionView {
            
        }
    }
    
    private func getAudioCell(for index: IndexPath) -> WEPronunciationAudioCollectionViewCell {
        let identifier = "WEPronunciationAudioCollectionViewCell"
        let cell = audiosCollectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                            for: index)
        if let mainCell = cell as? WEPronunciationAudioCollectionViewCell {
            // Init data
            mainCell.pronunciationLabel.text = audios[index.item]
            return mainCell
        } else {
            return WEPronunciationAudioCollectionViewCell()
        }
    }
    
    private func getStyleCell(for index: IndexPath) -> WEPronunciationStyleCollectionViewCell {
        let identifier = "WEPronunciationStyleCollectionViewCell"
        let cell = stylesCollectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                            for: index)
        if let mainCell = cell as? WEPronunciationStyleCollectionViewCell {
            // Init data
            mainCell.titleLabel.text = styles[index.item]
            return mainCell
        } else {
            return WEPronunciationStyleCollectionViewCell()
        }
    }
}

extension WEPronunciationViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        scrollDelegate?.scrollViewDidScroll(scrollView)
    }
}
