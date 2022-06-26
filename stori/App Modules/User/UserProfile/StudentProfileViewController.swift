//
//  StudentProfileViewController.swift
//  stori
//
//  Created by Alex on 20.06.2022.
//

import UIKit

class StudentProfileViewController: UIViewController {

    @IBOutlet weak var userLevelView: UIView!
    @IBOutlet weak var userLevelLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userBadgeView: UIView!
    @IBOutlet weak var userBadgeIconView: UIImageView!
    
    @IBOutlet weak var followersValueLabel: UILabel!
    @IBOutlet weak var followersTitleLabel: UILabel!
    
    @IBOutlet weak var followingValueLabel: UILabel!
    @IBOutlet weak var followingTitleLabel: UILabel!
    
    @IBOutlet weak var enrolledValueLabel: UILabel!
    @IBOutlet weak var enrolledTitleLabel: UILabel!
    
    @IBOutlet weak var storiesCollectionView: UICollectionView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        storiesCollectionView.register(StoryCollectionViewCell.nib(),
                                       forCellWithReuseIdentifier: StoryCollectionViewCell.identifier)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let minimumInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        storiesCollectionView.centerContentHorizontalyByInsetIfNeeded(minimumInset: minimumInset)
    }
    
    @IBAction func userBadgePressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            if self.userBadgeView.backgroundColor == .speaklWhite {
                self.userBadgeView.backgroundColor = .speaklGreen
                self.userBadgeIconView.image = UIImage(named: "check_mark_white")
            } else {
                self.userBadgeView.backgroundColor = .speaklWhite
                self.userBadgeIconView.image = UIImage(named: "plus")
            }
        }
        // TODO: Request follow/unfollow user
    }
}

extension StudentProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = Int.random(in: 0...5)
        noDataLabel.isHidden = count != 0
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionViewCell.identifier,
                                                          for: indexPath)
        if let cell = mainCell as? StoryCollectionViewCell {
            cell.cellHeightConstraint.constant = collectionView.frame.height
            cell.layoutIfNeeded()
            return cell
        }
        return mainCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Learn", bundle: nil)
        let nextScreen = storyBoard.instantiateViewController(withIdentifier: "MainStoryVideoListViewController")
        if let unwrappedNextScreen = nextScreen as? MainStoryVideoListViewController {
            unwrappedNextScreen.position = 0 // indexPath.item
//            if searchBar.text?.isEmpty ?? true {
//                unwrappedNextScreen.hashtag = trendingHashtags[indexPath.row]
//            } else {
//                unwrappedNextScreen.hashtag = searchedHashtags[indexPath.row]
//            }
            navigationController?.pushViewController(unwrappedNextScreen, animated: true)
        }
    }
}
