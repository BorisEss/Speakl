//
//  VideoPlayerView.swift
//  stori
//
//  Created by Alex on 01.09.2021.
//

import UIKit
import AVKit

protocol VideoPlayerViewProtocol: UIView {
    func load(file: LocalFile, isMuted: Bool, autoReplay: Bool, shouldPlay: Bool, muteAction: Bool)
    func load(url: String, isMuted: Bool, autoReplay: Bool, shouldPlay: Bool, muteAction: Bool)
    func load(player: AVPlayer, isMuted: Bool, autoReplay: Bool, shouldPlay: Bool, muteAction: Bool)
    func play()
    func pause()
    func mute()
    func unmute()
    func returnToBeginning()
    func setVolume(_ volume: Float)
    var isPlaying: Bool { get }
}

/// This is a custom made Video Player View, which loads AVPlayer to play a video inside the view.
///
class VideoPlayerView: UIView, VideoPlayerViewProtocol {

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
    @IBOutlet weak var activityIndicator: AppActivityIndicator!
    @IBOutlet weak var noDataLabel: UILabel!
    
    @IBOutlet weak var muteUnmuteView: UIView!
    @IBOutlet weak var muteUnmuteImageView: UIImageView!
    @IBOutlet weak var muteUnmuteButton: UIButton!
    
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
    
    @IBAction func muteUnmuteButtonPressed(_ sender: Any) {
        setPlayerMuted(player: &player, isMuted: !player.isMuted)
        showMuteUnmuteAnimation(isMuted: player.isMuted)
        muteChanged?(player.isMuted)
    }
    
    // MARK: - Loading data & actions
    func load(file: LocalFile,
              isMuted: Bool = false,
              autoReplay: Bool = false,
              shouldPlay: Bool = true,
              muteAction: Bool = false) {
        guard let urlString = file.url,
              let url = URL(string: urlString) else { return }
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        load(player: player,
             isMuted: isMuted,
             autoReplay: autoReplay,
             shouldPlay: shouldPlay,
             muteAction: muteAction)
    }
    
    func load(url: String,
              isMuted: Bool = false,
              autoReplay: Bool = false,
              shouldPlay: Bool = true,
              muteAction: Bool = false) {
        guard let url = URL(string: url) else { return }
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        load(player: player,
             isMuted: isMuted,
             autoReplay: autoReplay,
             shouldPlay: shouldPlay,
             muteAction: muteAction)
    }

    func load(player: AVPlayer,
              isMuted: Bool = false,
              autoReplay: Bool = false,
              shouldPlay: Bool = true,
              muteAction: Bool = false) {
        muteUnmuteButton.isEnabled = muteAction
        if !isLoaded {
            startAnimation()
            self.player = player
            let playerLayer = AVPlayerLayer(player: player)
            DispatchQueue.main.async {
                playerLayer.frame = self.videoView.frame
            }
            playerLayer.cornerRadius = cornerRadius
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.backgroundColor = UIColor.black.cgColor
            self.videoView.layer.addSublayer(playerLayer)
            self.videoView.cornerRadius = cornerRadius
            self.playerLayer = playerLayer
            setPlayerMuted(player: &self.player, isMuted: isMuted)
            self.autoReplay = autoReplay
            
            obs = self.player.currentItem?.observe(\.status,
                                                    options: [.new, .old],
                                                    changeHandler: { (playerItem, _) in
                self.stopAnimation()
                if playerItem.status == .unknown || playerItem.status == .failed {
                    self.playerItemFailedToPlay()
                }
            })
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(playerDidFinishPlaying),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: nil)
            if shouldPlay { self.player.play() }
            isLoaded = true
        } else {
            if isLoaded, !self.player.isPlaying {
                self.player.isMuted = isMuted
                self.player.play()
            }
        }
    }
    
    // MARK: - Set Up methods and callbacks
    private func setPlayerMuted(player: inout AVPlayer, isMuted: Bool) {
        player.isMuted = isMuted
        if !isMuted {
            do {
                  try AVAudioSession.sharedInstance().setCategory(.playback)
                  try AVAudioSession.sharedInstance().setActive(true)
               } catch {
                   print(error.localizedDescription)
               }
        }
    }
    
    @objc private func playerDidFinishPlaying(note: NSNotification) {
        if let receivedItem = note.object as? AVPlayerItem,
           let currentItem = player.currentItem,
           receivedItem == currentItem {
            didFinishPlaying?()
            if autoReplay {
                player.seek(to: CMTime.zero)
                player.play()
            }
        }
    }
    
    private func playerItemFailedToPlay() {
        noDataLabel.isHidden = false
        didFail?()
    }
    
    // MARK: - Video Player actions
    var isMuted: Bool {
        return player.isMuted
    }
    
    var muteChanged: ((_ isMuted: Bool) -> Void)?
    
    func mute() {
        setPlayerMuted(player: &player, isMuted: true)
    }
    
    func unmute() {
        setPlayerMuted(player: &player, isMuted: false)
    }
    
    func returnToBeginning() {
        player.seek(to: CMTime.zero)
    }
    
    func setVolume(_ volume: Float) {
        player.volume = volume
    }
    
    var isPlaying: Bool {
        return player.isPlaying
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func clear() {
        player.pause()
        player.isMuted = true
        player.replaceCurrentItem(with: nil)
        player = AVPlayer()
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        isLoaded = false
        obs = nil
        NotificationCenter.default.removeObserver(self,
                                                  name: .AVPlayerItemDidPlayToEndTime,
                                                  object: nil)
    }
    
    private func startAnimation() {
        activityIndicator.startAnimating()
    }
    
    private func stopAnimation() {
        activityIndicator.stopAnimating()
    }
    
    private func showMuteUnmuteAnimation(isMuted: Bool) {
        muteUnmuteImageView.image = UIImage(named: isMuted ? "video_mute" : "video_unmute")
        showMuteUnmuteBaseAnimation()
    }
    
    private func showMuteUnmuteBaseAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            self.muteUnmuteView.alpha = 1
            self.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 0.8, delay: 0.5, options: .curveLinear) {
                self.muteUnmuteView.alpha = 0
                self.layoutIfNeeded()
            } completion: { _ in }
        }
    }
    
    deinit {
        if isLoaded {
            clear()
        } else {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
}
