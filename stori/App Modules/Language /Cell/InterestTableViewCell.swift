//
//  InterestTableViewCell.swift
//  stori
//
//  Created by Alex on 07.04.2021.
//

import UIKit
import TagListView

class InterestTableViewCell: UITableViewCell, CustomTableViewCell {

    static var height: CGFloat = 40
    
    var beginUpdate: (() -> Void)?
    var endUpdate: (() -> Void)?
    var interestAction: ((_ isSelected: Bool, _ interest: String) -> Void)?

    private var interest: Interest?
    private var isDrowpdownShown: Bool = false {
        didSet {
            arrowImageView.image = UIImage(named: isDrowpdownShown ? "tint_bottom_arrow" : "tint_right_arrow")
            beginUpdate?()
            interestsView.isHidden = !isDrowpdownShown
            layoutIfNeeded()
            endUpdate?()
        }
    }
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var interestsView: UIView!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var tagListWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let interest = interest {
            setUp(interest: interest)
        }
        tagListView.textFont = UIFont(name: "IBMPlexSans-Light", size: 14) ?? .systemFont(ofSize: 14)
        tagListView.delegate = self
        tagListView.marginX = 8
        tagListView.marginY = 8
    }
    
    @IBAction func drowpdownPressed(_ sender: Any) {
        isDrowpdownShown = !isDrowpdownShown
    }
    
    func setUp(interest: Interest) {
        self.interest = interest
        iconImageView.load(url: URL(string: "https://cdn-icons-png.flaticon.com/512/141/141783.png"))
        // interest.imageUrl)
        nameLabel.text = "Interests" // interest.name
        
        var items = [
            "Sports", "Outdoor activities", "Technology", "Art", "Travel", "Foreign languages", "Video games",
            "Music", "Social-related activities", "Camping", "Fishing", "Gardening", "Hiking", "Mountain climbing",
            "Trekking", "Coding", "Content creation", "Podcasting", "Writing", "Photo and video editing",
            "Dance", "Drawing", "Graphic design", "Painting", "Pottery", " Photography", "Sculpting", "Beatboxing",
            "Guitar", "Piano", "Singing", "Songwriting", "Trumpet", "Board games", "Public speaking"
        ]
        items.shuffle()
        let numberOfItems = Int.random(in: 3...items.count)
        let newItems: [String] = Array(items[0..<numberOfItems])
        getSizeForWords(words: newItems)
        DispatchQueue.main.async {
            self.tagListView.removeAllTags()
            self.tagListView.addTags(newItems)
            self.tagListView.layoutIfNeeded()
        }
    }
    
    func getSizeForWords(words: [String]) {
        var totalSize: CGFloat = 0
        for item in words {
            totalSize += item.width(withConstrainedHeight: 30, font: .IBMPlexSansLight(size: 14))
        }
        tagListWidthConstraint.constant = totalSize * 1.5 / 3
    }
}

extension InterestTableViewCell: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        tagView.isSelected = !tagView.isSelected
        if sender.selectedTags().isEmpty {
            nameLabel.text = "Interests"
        } else {
            nameLabel.text = "Interests (\(sender.selectedTags().count))"
        }
        interestAction?(tagView.isSelected, title)
    }
}
