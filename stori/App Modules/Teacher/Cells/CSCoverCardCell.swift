//
//  CSCoverCardCell.swift
//  stori
//
//  Created by Alex on 27.01.2021.
//

import UIKit
import VerticalCardSwiper

class CSCoverCardCell: CardCell, CustomCollectionViewCell {
    
    var didSelect: ((CoverImage) -> Void)?
    
    var image: CoverImage?
    var topic: Topic?
    var subCategory: SubCategory?

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var subCategoryLabel: UILabel!
    
    @IBOutlet weak var selectButton: RegularButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpLanguage()
        guard let image = image else { return }
        setImage(image: image, topic: topic, subCategory: subCategory)
    }

    func setImage(image: CoverImage,
                  topic: Topic?,
                  subCategory: SubCategory?) {
        self.image = image
        self.topic = topic
        self.subCategory = subCategory
        categoryLabel.text = topic?.name
        subCategoryLabel.text = subCategory?.name
        coverImageView.load(url: image.imageUrl)
    }
    
    private func setUpLanguage() {
        selectButton.setTitle("cs_covers_choose".localized, for: .normal)
    }
    
    @IBAction func selectButtonIsSelected(_ sender: Any) {
        guard let image = image else { return }
        didSelect?(image)
    }
}
