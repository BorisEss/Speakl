//
//  TutorialCollectionViewCell.swift
//  stori
//
//  Created by Alex on 19.11.2020.
//

import UIKit

typealias TutorialValue = (id: Int, image: UIImage?, description: String?)

class TutorialCollectionViewCell: UICollectionViewCell, CustomCollectionViewCell {

    @IBOutlet weak var tutorialIcon: UIImageView!
    @IBOutlet weak var tutorialLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.tutorialLabel.alpha = self.isSelected ? 1 : 0
            }
        }
    }
    
    func setUp(_ value: TutorialValue) {
        tutorialIcon.image = value.image
        tutorialLabel.text = value.description
    }
}
