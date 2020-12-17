//
//  TutorialViewController.swift
//  stori
//
//  Created by Alex on 19.11.2020.
//

import UIKit
import UPCarouselFlowLayout

class TutorialViewController: UIViewController {
    
    // MARK: - Variables
    private let tutorialItems: [TutorialValue] = [
        (UIImage(named: "welcome_item_first"), "start_tutorial_vc_page_one_title".localized),
        (UIImage(named: "welcome_item_second"), "start_tutorial_vc_page_two_title".localized),
        (UIImage(named: "welcome_item_third"), "start_tutorial_vc_page_three_title".localized)
    ]
    private var currentPage: Int = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: RegularButton!
    
    // MARK: - Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollectionView()
        setUpLanguage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.collectionView.collectionViewLayout = self.prepareLayout()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Button Actions
    @IBAction func nextButtonPressed(_ sender: Any) {
        DefaultSettings.finishedTutorial = true
        Router.load()
    }
    
    // MARK: - Set Up
    private func setUpCollectionView() {
        collectionView.register(TutorialCollectionViewCell.nib(),
                                forCellWithReuseIdentifier: TutorialCollectionViewCell.identifier)
        
        collectionView.allowsMultipleSelection = false
        collectionView.selectItem(at: IndexPath(item: 0, section: 0),
                                  animated: true,
                                  scrollPosition: .centeredHorizontally)
    }
    
    private func setUpLanguage() {
        nextButton.setTitle("start_tutorial_vc_button_title_start".localized, for: .normal)
    }
    
    private func prepareLayout() -> UICollectionViewFlowLayout {
        let layout = UPCarouselFlowLayout()
        var minValue = collectionView.bounds.width
        if collectionView.bounds.width > collectionView.bounds.height {
            minValue = collectionView.bounds.height
        }
        layout.itemSize = CGSize(width: minValue,
                                 height: minValue)
        layout.scrollDirection = .horizontal
        layout.spacingMode = .fixed(spacing: -(minValue/3))
        return layout
    }
    
    private var pageSize: CGSize {
        if let layout = self.collectionView.collectionViewLayout as? UPCarouselFlowLayout {
            var pageSize = layout.itemSize
            if layout.scrollDirection == .horizontal {
                pageSize.width += layout.minimumLineSpacing
            } else {
                pageSize.height += layout.minimumLineSpacing
            }
            return pageSize
        } else {
            return .zero
        }
    }

    // MARK: - Scroll View delegation
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let layout = self.collectionView.collectionViewLayout as? UPCarouselFlowLayout {
            let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
            var offset = scrollView.contentOffset.y
            if layout.scrollDirection == .horizontal {
                offset = scrollView.contentOffset.x
            }
            currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
            
            collectionView.selectItem(at: IndexPath(item: currentPage, section: 0),
                                      animated: false,
                                      scrollPosition: .centeredHorizontally)
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension TutorialViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return tutorialItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TutorialCollectionViewCell.identifier,
                                                         for: indexPath) as? TutorialCollectionViewCell {
            cell.setUp(tutorialItems[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TutorialViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var minValue = collectionView.bounds.width
        if collectionView.bounds.width > collectionView.bounds.height {
            minValue = collectionView.bounds.height
        }
        return CGSize(width: minValue,
                      height: minValue)
    }
}
