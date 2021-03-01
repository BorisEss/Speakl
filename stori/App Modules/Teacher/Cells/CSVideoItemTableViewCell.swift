//
//  CSVideoItemTableViewCell.swift
//  stori
//
//  Created by Alex on 01.02.2021.
//

import UIKit
import MobileVLCKit

class CSVideoItemTableViewCell: CSTableViewCell {

    var sectionFile: StoryVideoSection?
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var thumbnailHeight: NSLayoutConstraint!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var progressActivityIndicator: UIActivityIndicatorView!
    
    let vlcMediaPlayer = VLCMediaPlayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if let section = sectionFile {
            setUp(section: section)
        }
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        editActionCallback?()
    }
    
    @IBAction func playPauseButtonPressed(_ sender: Any) {
        if vlcMediaPlayer.isPlaying {
            UIView.transition(from: videoPlayerView,
                              to: thumbnailImageView,
                              duration: 0.4,
                              options: [.transitionCrossDissolve,
                                        .layoutSubviews,
                                        .showHideTransitionViews],
                              completion: nil)
            vlcMediaPlayer.stop()
            playPauseButton.setImage(UIImage(named: "play_big"), for: .normal)
        } else {
            guard let urlString = sectionFile?.file.url,
                  let url = URL(string: urlString) else { return }
            vlcMediaPlayer.media = VLCMedia(url: url)
            UIView.transition(from: thumbnailImageView,
                              to: videoPlayerView,
                              duration: 0.4,
                              options: [.transitionCrossDissolve,
                                        .layoutSubviews,
                                        .showHideTransitionViews],
                              completion: nil)
            vlcMediaPlayer.play()
            playPauseButton.setImage(UIImage(named: "pause_big"), for: .normal)
        }
    }
    
    func setUp(section: StoryVideoSection) {
        vlcMediaPlayer.drawable = videoPlayerView
        vlcMediaPlayer.delegate = self
        let cellWidth = UIScreen.main.bounds.width - 40
        self.sectionFile = section
        if let thumbnail = section.file.image {
            let ratio = cellWidth / thumbnail.size.width
            self.thumbnailHeight.constant = thumbnail.size.height * ratio
        }
        self.thumbnailImageView.image = section.file.image
        if !section.finishedUpload {
            startUploading()
            section.didFinishUpload = {
                self.stopUploading()
            }
        } else {
            stopUploading()
        }
    }
    
    func startUploading() {
        progressActivityIndicator.startAnimating()
        editButton.isEnabled = false
        playPauseButton.isEnabled = false
        thumbnailImageView.alpha = 0.7
    }
    
    func stopUploading() {
        progressActivityIndicator.stopAnimating()
        editButton.isEnabled = true
        playPauseButton.isEnabled = true
        thumbnailImageView.alpha = 1
    }
}

extension CSVideoItemTableViewCell: VLCMediaPlayerDelegate {
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        guard let state = (aNotification.object as? VLCMediaPlayer)?.state else {
            return
        }
        if state == .stopped {
            videoPlayerView.isHidden = true
            thumbnailImageView.isHidden = false
            vlcMediaPlayer.stop()
            playPauseButton.setImage(UIImage(named: "play_big"), for: .normal)
        }
    }
}
