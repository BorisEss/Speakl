//
//  ReviewTopicsTableViewCell.swift
//  stori
//
//  Created by Alex on 28.04.2022.
//

import UIKit
import SDWebImage

protocol ReviewTopicsTableViewCellDelegate: AnyObject {
    func didSelectTopic(topic: Topic)
}

class ReviewTopicsTableViewCell: UITableViewCell, CustomTableViewCell {
    
    var topics: [Topic] = [
        Topic(id: 0, name: "Animals", image: "https://www.dailymaverick.co.za/wp-content/uploads/Op-Ed-Pinnock-1600x901-1.jpeg"),
        Topic(id: 1, name: "Appearance", image: "https://i0.wp.com/psychlearningcurve.org/wp-content/uploads/2017/01/5-ways-to-cultivate-a-professional-appearance-when-presenting-your-research.jpg"),
        Topic(id: 2, name: "Communication", image: "https://assets-global.website-files.com/61766c42e8e50c99a04fbd4b/6179ba127b7b274cf1e3f07d_1509990774-communication-both-ways-article.png"),
        Topic(id: 3, name: "Culture", image: "https://www.tandemmadrid.com/tandem/wp-content/uploads/2013/01/programa-cultural-tandem1.jpg"),
        Topic(id: 4, name: "Food,Drink", image: "https://www.nationaltheatre.org.uk/sites/default/files/kerb_understudy-hot-sandwich-1280x720.jpg"),
        Topic(id: 5, name: "Functions", image: "https://cdn.searchenginejournal.com/wp-content/uploads/2020/08/1678bd65-7ffa-49ad-b999-fc5340ba2130-5f3f05393a746-760x400.jpeg"),
        Topic(id: 6, name: "Health", image: "https://bernaltrivino.com/wp-content/uploads/2021/08/1.jpg")
    ]

    weak var delegate: ReviewTopicsTableViewCellDelegate?
    
    @IBOutlet weak var topicView: UIView!
    @IBOutlet weak var topicImageView: UIImageView!
    @IBOutlet weak var topicNameLabel: UILabel!
    
    @IBOutlet weak var topicsCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        topicsCollectionView.delegate = self
        topicsCollectionView.dataSource = self
        topicsCollectionView.register(ReviewTopicCollectionViewCell.nib(),
                                      forCellWithReuseIdentifier: ReviewTopicCollectionViewCell.identifier)
    }
    
    func setTopic(topic: Topic?) {
        if let topic = topic {
            topicView.isHidden = false
            topicsCollectionView.isHidden = true
            topicImageView.sd_setImage(with: topic.imageUrl)
            topicNameLabel.text = topic.name
        } else {
            topicsCollectionView.isHidden = false
            topicView.isHidden = true
            topicsCollectionView.reloadData()
        }
    }
}

extension ReviewTopicsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewTopicCollectionViewCell.identifier,
                                                          for: indexPath)
        if let cell = mainCell as? ReviewTopicCollectionViewCell {
            cell.setUp(topic: topics[indexPath.item])
            return cell
        }
        return mainCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectTopic(topic: topics[indexPath.item])
    }
}
