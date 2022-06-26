//
//  TeacherProfileViewController.swift
//  stori
//
//  Created by Alex on 20.06.2022.
//

import UIKit

class TeacherProfileViewController: UIViewController {

    var reviewsAreShown: Bool = true {
        didSet {
            tabSegmentedControl.removeAllSegments()
            tabSegmentedControl.insertSegment(withTitle: "Stories", at: 0, animated: true)
            if reviewsAreShown {
                tabSegmentedControl.insertSegment(withTitle: "Reviews", at: 1, animated: true)
                tabSegmentedControl.insertSegment(withTitle: "Experience", at: 2, animated: true)
            } else {
                tabSegmentedControl.insertSegment(withTitle: "Experience", at: 1, animated: true)
            }
            tabSegmentedControl.selectedSegmentIndex = 0
        }
    }
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userBadgeView: UIView!
    @IBOutlet weak var userBadgeIconView: UIImageView!
    
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var followersValueLabel: UILabel!
    @IBOutlet weak var followersTitleLabel: UILabel!
    
    @IBOutlet weak var studentsValueLabel: UILabel!
    @IBOutlet weak var studentsTitleLabel: UILabel!
    
    @IBOutlet weak var likesValueLabel: UILabel!
    @IBOutlet weak var likesTitleLabel: UILabel!
    
    @IBOutlet weak var tabSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var storiesView: UIView!
    @IBOutlet weak var storiesCollectionView: UICollectionView!
    @IBOutlet weak var noStoriesLabel: UILabel!
    
    @IBOutlet weak var reviewsView: UIView!
    @IBOutlet weak var reviewsStackView: UIStackView!
    @IBOutlet weak var reviewsSeeMoreButton: UIButton!
    
    @IBOutlet weak var experienceView: UIView!
    @IBOutlet weak var experienceStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        storiesCollectionView.register(StoryCollectionViewCell.nib(),
                                       forCellWithReuseIdentifier: StoryCollectionViewCell.identifier)
        reviewsAreShown = Bool.random()
        
        loadUserReviews()
        
        loadUserExperience()
    }
    
    private func loadUserExperience() {
        let experience1View = TeacherExperienceView()
        experience1View.titleLabel.text = "Cambridge English Test"
        experience1View.descriptionLabel.text = "Level C1"
        
        let experience2View = TeacherExperienceView()
        experience2View.titleLabel.text = "CELTA - Cambridge University"
        experience2View.descriptionLabel.text = """
        The essential TEFL qualification that’s trusted by employers, language schools and governments around the world.
        """
        
        let experience3View = TeacherExperienceView()
        experience3View.titleLabel.text = "160 hour TESOL/TESL/TEFL Teacher Training Certification"
        experience3View.descriptionLabel.text = """
        Focused on lesson planning, classroom management, techniques, skills development, teaching grammar,
        teaching strategies, teaching multi-level classes, fundamentals of language acquisition,
        communicative teaching theory and a teaching practicum.
        """
        
        let experience4View = TeacherExperienceView()
        experience4View.titleLabel.text = "Cambridge Speaking Examiner"
        experience4View.descriptionLabel.text = "International House Ecuador - Quito and Guayaquil, Ecuador"
        
        experienceStackView.addArrangedSubview(experience1View)
        experienceStackView.addArrangedSubview(experience2View)
        experienceStackView.addArrangedSubview(experience3View)
        experienceStackView.addArrangedSubview(experience4View)
    }
    
    private func loadUserReviews() {
        reviewsStackView.removeArrangedSubview(reviewsSeeMoreButton)
        guard reviewsAreShown else { return }
        
        let review1 = TeacherUserReviewView()
        review1.handleTap = {
            self.performSegue(withIdentifier: "showUserDetails", sender: nil)
        }
        let review2 = TeacherUserReviewView()
        review2.handleTap = {
            self.performSegue(withIdentifier: "showUserDetails", sender: nil)
        }
        let review3 = TeacherUserReviewView()
        review3.handleTap = {
            self.performSegue(withIdentifier: "showUserDetails", sender: nil)
        }
        let review4 = TeacherUserReviewView()
        review4.handleTap = {
            self.performSegue(withIdentifier: "showUserDetails", sender: nil)
        }
        let review5 = TeacherUserReviewView()
        review5.handleTap = {
            self.performSegue(withIdentifier: "showUserDetails", sender: nil)
        }
        
        reviewsStackView.addArrangedSubview(review1)
        reviewsStackView.addArrangedSubview(review2)
        reviewsStackView.addArrangedSubview(review3)
        reviewsStackView.addArrangedSubview(review4)
        reviewsStackView.addArrangedSubview(review5)
        reviewsStackView.addArrangedSubview(reviewsSeeMoreButton)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let minimumInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        storiesCollectionView.centerContentHorizontalyByInsetIfNeeded(minimumInset: minimumInset)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let nextVc = segue.destination as? UserProfileViewController {
            nextVc.isTeacher = false
        }
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
    
    @IBAction func tabSegmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            storiesView.isHidden = false
            reviewsView.isHidden = true
            experienceView.isHidden = true
        case 1:
            if reviewsAreShown {
                storiesView.isHidden = true
                reviewsView.isHidden = false
                experienceView.isHidden = true
            } else {
                storiesView.isHidden = true
                reviewsView.isHidden = true
                experienceView.isHidden = false
            }
        case 2:
            if reviewsAreShown {
                storiesView.isHidden = true
                reviewsView.isHidden = true
                experienceView.isHidden = false
            }
        default: break
        }
    }
}

extension TeacherProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = Int.random(in: 0...5)
        noStoriesLabel.isHidden = count != 0
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
            navigationController?.pushViewController(unwrappedNextScreen, animated: true)
        }
    }
}
