//
//  TeacherReviewsViewController.swift
//  stori
//
//  Created by Alex on 26.06.2022.
//

import UIKit

class TeacherReviewsViewController: UIViewController {

    @IBOutlet weak var reviewsStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let items = Int.random(in: 5...20)
        
        for _ in 1...items {
            let review = TeacherUserReviewView()
            review.handleTap = {
                self.performSegue(withIdentifier: "showUserDetails", sender: nil)
            }
            reviewsStackView.addArrangedSubview(review)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let nextVc = segue.destination as? UserProfileViewController {
            nextVc.isTeacher = false
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
