//
//  WEPronunciationAudioCollectionViewCell.swift
//  stori
//
//  Created by Alex on 05.01.2022.
//

import UIKit

class WEPronunciationAudioCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBOutlet weak var backgroundWaves: UIImageView!
    @IBOutlet weak var backgroundWavesWidth: NSLayoutConstraint!
    
    @IBOutlet weak var pronunciationLabel: UILabel!
    
    @IBAction func playPauseButtonPressed(_ sender: Any) {
        playPauseButton.setImage(UIImage(named: "pause.fill"), for: .normal)
        backgroundWavesWidth.constant = 0
        backgroundWaves.isHidden = false
        layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.backgroundWavesWidth.constant = 140
            self.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
                self.backgroundWavesWidth.constant = 120
                self.layoutIfNeeded()
            } completion: { _ in
                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
                    self.backgroundWavesWidth.constant = 140
                    self.layoutIfNeeded()
                } completion: { _ in
                    UIView.animate(withDuration: 1, delay: 0.4, options: .curveEaseOut) {
                        self.playPauseButton.setImage(UIImage(named: "play.fill"), for: .normal)
                        self.backgroundWavesWidth.constant = 0
                        self.layoutIfNeeded()
                    } completion: { _ in
                        self.backgroundWaves.isHidden = true
                    }
                }
            }
        }
    }
}
