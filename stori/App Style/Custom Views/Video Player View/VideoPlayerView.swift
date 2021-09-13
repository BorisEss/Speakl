//
//  VideoPlayerView.swift
//  stori
//
//  Created by Alex on 01.09.2021.
//

import UIKit
import AVKit

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
    
    deinit {
        if isLoaded {
//            stop()
        } else {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
}
