//
//  SearchHashtagTableViewCell.swift
//  stori
//
//  Created by Alex on 14.12.2021.
//

import UIKit

class SearchHashtagTableViewCell: UITableViewCell {

    @IBOutlet weak var hashtagLabel: UILabel!
    @IBOutlet weak var storiesCountLabel: UILabel!
    
    func setUp(hashtag: String, count: Int) {
        hashtagLabel.text = hashtag
        // TODO: Make the count look pretier
        // `count < 100` -> Fewer than 100 stories
        // `100 <= count < 200` -> 100+ stories
        // `200 <= count < 300` -> 200+ stories
        // `1000 <= count < 1100` -> 1000+ stories
        // `1100 <= count < 1200` -> 1.1k stories
        // `999900 <= count < 1000000` -> 999.9k stories
        // `1000000 <= count < 1100000` -> 1M stories
        // `1100000 <= count < 1200000` -> 1.1M stories
        storiesCountLabel.text = "\(count) stories"
    }

}
