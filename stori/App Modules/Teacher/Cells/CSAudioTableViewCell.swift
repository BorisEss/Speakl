//
//  CSAudioTableViewCell.swift
//  stori
//
//  Created by Alex on 27.01.2021.
//

import UIKit

class CSAudioTableViewCell: UITableViewCell, CustomTableViewCell {
    
    private var file: BackgroundAudio?
    
    static let height: CGFloat = 96

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var checkMarkImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        guard let file = file else { return }
        setUpAudio(file: file)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        checkMarkImage.isHidden = !selected
    }
    
    func setUpAudio(file: BackgroundAudio) {
        self.file = file
        nameLabel.text = file.name
        let minutes = String(format: "%02d", file.detailedDuration.minutes)
        let seconds = String(format: "%02d", file.detailedDuration.seconds)
        timeLabel.text = "\(minutes):\(seconds)"
    }
}
