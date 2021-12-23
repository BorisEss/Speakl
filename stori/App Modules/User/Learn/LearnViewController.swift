//
//  LearnViewController.swift
//  stori
//
//  Created by Alex on 19.08.2021.
//

import UIKit

var learnTabIsMuted: Bool = false

class LearnViewController: UIViewController {

    var tabs: [String] = [
        "Animals",
        "Appearence",
        "Communication",
        "Culture",
        "Food,Drink",
        "Functions",
        "Health"
    ]
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var swipeMenuCollectionView: UICollectionView!
    @IBOutlet weak var pullToRefreshView: UIView!
    @IBOutlet weak var pullToRefreshLabel: UILabel!
    @IBOutlet weak var pullToRefreshActivityIndicator: AppActivityIndicator!
    
    @IBOutlet weak var cView: UIView!
    @IBOutlet weak var activityIndicator: AppActivityIndicator!
    
    @IBOutlet weak var inProgressTutorialView: UIView!
    
    private var refreshVibration: Bool = false
    private var previousIndexPath: IndexPath = IndexPath()
    private var storiesListVc: StoryVideoListViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previousIndexPath = IndexPath(item: 2, section: 0)
        swipeMenuCollectionView.selectItem(at: previousIndexPath,
                                           animated: false,
                                           scrollPosition: [])
        swipeMenuCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0),
                                             at: .left,
                                             animated: false)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        cView.alpha = 0
        activityIndicator.startAnimating()
        storiesListVc?.loadForYou {
            UIView.animate(withDuration: 0.3) {
                self.cView.alpha = 1
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        swipeMenuCollectionView.centerContentHorizontalyByInsetIfNeeded(minimumInset: UIEdgeInsets.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (tabBarController as? MainTabBarViewController)?.setTransparent()
        
        if !DefaultSettings.hasShownInProgressTutorial {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                UIView.animate(withDuration: 0.7) {
                    self.inProgressTutorialView.alpha = 1
                } completion: { _ in
                    self.swipeMenuCollectionView.scrollToItem(at: IndexPath(item: 0,
                                                                            section: 0),
                                                              at: .left,
                                                              animated: true)
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let nextVc = segue.destination as? StoryVideoListViewController {
            self.storiesListVc = nextVc
            nextVc.animationDelegate = self
        }
        if let nextVc = segue.destination as? InProgressTutorialViewController {
            nextVc.inProgressTutorialDelegate = self
        }
    }
}

extension LearnViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabs.count + 3
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LearnCategoryCollectionViewCell",
                                                          for: indexPath)
        if let cell = mainCell as? LearnCategoryCollectionViewCell {
            if indexPath.item == 0 {
                cell.setUp(title: "In Progress")
            } else if indexPath.item == 1 {
                cell.setUp(title: "Search", icon: UIImage(named: "search_icon"))
                // Search
            } else if indexPath.item == 2 {
                cell.setUp(title: "For You")
                // For you
            } else {
                cell.setUp(title: tabs[indexPath.item - 3])
                // other categories
            }
            return cell
        }
        return mainCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            cView.alpha = 0
            activityIndicator.startAnimating()
            print("Load In Progress")
            storiesListVc?.loadInProgress {
                UIView.animate(withDuration: 0.3) {
                    self.cView.alpha = 1
                }
                self.activityIndicator.stopAnimating()
            }
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            previousIndexPath = indexPath
        } else if indexPath.item == 1 {
            performSegue(withIdentifier: "showSearch", sender: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                collectionView.selectItem(at: self.previousIndexPath, animated: true, scrollPosition: [])
                collectionView.collectionViewLayout.invalidateLayout()
            }
        } else if indexPath.item == 2 {
            cView.alpha = 0
            activityIndicator.startAnimating()
            print("Load For You")
            storiesListVc?.loadForYou {
                UIView.animate(withDuration: 0.3) {
                    self.cView.alpha = 1
                }
                self.activityIndicator.stopAnimating()
            }
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            previousIndexPath = indexPath
        } else {
            cView.alpha = 0
            activityIndicator.startAnimating()
            storiesListVc?.loadCategory {
                UIView.animate(withDuration: 0.3) {
                    self.cView.alpha = 1
                }
                self.activityIndicator.stopAnimating()
            }
            print("Load specific category: \(tabs[indexPath.item - 3])")
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            previousIndexPath = indexPath
        }
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension LearnViewController: StoryVideoListViewControllerDelegate {
    func beginAnimation() {
        pullToRefreshLabel.text = "Pull to refresh"
        pullToRefreshActivityIndicator.isHidden = true
    }
    
    func animating(value: CGFloat) {
        menuView.alpha = 1 - (value / 100)
        pullToRefreshView.alpha = value/100
        if value >= 100, !refreshVibration { Vibration().light() }
        refreshVibration = value >= 100
    }
    
    func endAnimation(value: CGFloat) {
        refreshVibration = false
        if value < 70 {
            menuView.alpha = 1
            pullToRefreshView.alpha = 0
            pullToRefreshActivityIndicator.isHidden = true
            pullToRefreshActivityIndicator.stopAnimating()
        } else {
            Vibration().medium()
            menuView.alpha = 0
            pullToRefreshView.alpha = 1
            pullToRefreshLabel.text = "Loading..."
            pullToRefreshActivityIndicator.isHidden = false
            pullToRefreshActivityIndicator.startAnimating()
        }
    }
}

extension LearnViewController: InProgressTutorialViewControllerDelegate {
    func didReceiveTouch() {
        UIView.animate(withDuration: 0.5) {
            self.inProgressTutorialView.alpha = 0
        } completion: { _ in
            DefaultSettings.hasShownInProgressTutorial = true
        }
        
    }
}
