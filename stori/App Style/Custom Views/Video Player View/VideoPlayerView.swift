//
//  VideoPlayerView.swift
//  stori
//
//  Created by Alex on 01.09.2021.
//

import UIKit
import AVKit

/// This is a custom made Video Player View, which loads AVPlayer to play a video inside the view.
///
class VideoPlayerView: UIView {

    // MARK: - View initializers
    let contentXibName = "VideoPlayerView"
    
    @objc lazy private var player: AVPlayer = AVPlayer()
    lazy var isLoaded: Bool = false
    lazy private var obs: NSKeyValueObservation? = nil
    lazy private var playerLayer: AVPlayerLayer? = nil
    lazy private var autoReplay: Bool = false

    var didFail: (() -> Void)?
    var didFinishPlaying: (() -> Void)?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    // MARK: - View Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    func commonInit() {
        Bundle.main.loadNibNamed(contentXibName, owner: self, options: nil)
        contentView.fixInView(self)
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isLoaded {
            playerLayer?.frame = self.videoView.bounds
        }
    }
    
    // MARK: - Loading data & actions
    
    func load(file: LocalFile) {
        if file.fileType == .video,
           let urlString = file.url,
           let url = URL(string: urlString) {
            let item = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: item)
        } else {
            return
        }
    }
    
    func load(player: AVPlayer,
              isMuted: Bool = false,
              autoReplay: Bool = false,
              shouldPlay: Bool = false) {
        
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func clear() {
        
    }
    
    func mute(_ isMuted: Bool) {
        
    }
    
    deinit {
        if isLoaded {
//            stop()
        } else {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
}
