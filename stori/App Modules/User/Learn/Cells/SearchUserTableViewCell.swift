//
//  SearchUserTableViewCell.swift
//  stori
//
//  Created by Alex on 14.12.2021.
//

import UIKit

class SearchUserTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var studentsCountLabel: UILabel!
    
    func setUp(image: UIImage?, name: String, studentsCount: Int) {
        userImageView.image = image // load(stringUrl: image)
        userNameLabel.text = name
        // TODO: Make the students count show in a pretty mode
        // `count < 100` -> Fewer than 100 students
        // `100 <= count < 1000` -> 100 students
        // `1000 <= count < 1100` -> 1K students
        // `1100 <= count < 1200` -> 1.1K students
        // `1000000 <= count < 1100000` -> 1M students
        // `1100000 <= count < 1200000` -> 1.1M students
        studentsCountLabel.text = "\(studentsCount) students"
    }

}
