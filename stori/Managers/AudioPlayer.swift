//
//  AudioPlayer.swift
//  stori
//
//  Created by Alex on 28.01.2021.
//

import Foundation
import MobileVLCKit
import AVKit

class AudioPlayer {
    
    static let shared = AudioPlayer()
    
    private let player: AVPlayer
    private var progressTimer: Timer?
    
    var didUpdatePlayPause: ((_ isPlaying: Bool) -> Void)?
    var didUpdateProgress: ((_ progress: Double) -> Void)?
    var didUpdateProgressTime: ((_ seconds: Double) -> Void)?
    var didReturnTime: ((_ min: String, _ max: String) -> Void)?
    var didFinishPlaying: (() -> Void)?
    
    var author: String?
    var title: String?
    var album: String?
    
    var minTime: String? {
        if let currentTime = self.player.currentItem?.currentTime().seconds {
            let currentTimeSec: Int = Int(currentTime) % 60
            let currentTimeMin: Int = Int(currentTime) / 60
            return String(format: "%d:%02d",
                          currentTimeMin,
                          currentTimeSec)
        }
        return nil
    }
    var maxTime: String? {
        if let currentTime = self.player.currentItem?.currentTime().seconds,
           let duration = self.player.currentItem?.duration.seconds,
           !duration.isNaN, !currentTime.isNaN {
            let remainingTime = duration - currentTime
            let remainingTimeSec: Int = Int(remainingTime) % 60
            let remainingTimeMin: Int = Int(remainingTime) / 60
            return String(format: "-%d:%02d",
                          remainingTimeMin,
                          remainingTimeSec)
        }
        return nil
    }
    
    var isPlaying: Bool {
        return player.isPlaying
    }
    
    init() {
        player = AVPlayer()
    }
    
    func load(url: URL) {
        stop()
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: playerItem)
        player.replaceCurrentItem(with: playerItem)
    }
    
    func load(item: BackgroundAudio) {
//        stop()
//        guard let url = item.fileUrl else { return }
//        let media = VLCMedia(url: url)
//        player.media = media
//        togglePlayPause()
//        author = item.author
//        title = item.name
//        album = item.album
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        didFinishPlaying?()
    }
    
    func stop() {
        author = nil
        title = nil
        album = nil
        player.pause()
        player.replaceCurrentItem(with: nil)
        progressTimer?.invalidate()
        progressTimer = nil
    }
    
    func play() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord,
                                         mode: .spokenAudio,
                                         options: .defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch { }
        player.play()
        progressTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if let currentTime = self.player.currentItem?.currentTime().seconds,
               let duration = self.player.currentItem?.duration.seconds {
                self.didUpdateProgressTime?(currentTime)
                self.didUpdateProgress?(currentTime/duration)
                
                let currentTimeSec: Int = Int(currentTime) % 60
                let currentTimeMin: Int = Int(currentTime) / 60
                
                let remainingTime = duration - currentTime
                let remainingTimeSec: Int = Int(remainingTime) % 60
                let remainingTimeMin: Int = Int(remainingTime) / 60
                
                self.didReturnTime?(String(format: "%d:%02d",
                                          currentTimeMin,
                                          currentTimeSec),
                                    String(format: "-%d:%02d",
                                           remainingTimeMin,
                                           remainingTimeSec))
            }
        }
    }
    
    func pause() {
        player.pause()
        progressTimer?.invalidate()
    }
    
    func togglePlayPause() {
        if player.isPlaying {
            pause()
        } else {
            play()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.didUpdatePlayPause?(self.player.isPlaying)
        }
    }
    
    func skipForward(seconds: Int = 2) {
        guard let duration  = player.currentItem?.duration else {
            return
        }
        let playerCurrentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = playerCurrentTime + Double(seconds)
        
        if newTime < CMTimeGetSeconds(duration) {
            
            let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
            player.seek(to: time2)
        }
    }
    
    func skipBackward(seconds: Int = 2) {
        let playerCurrentTime = CMTimeGetSeconds(player.currentTime())
        var newTime = playerCurrentTime - Double(seconds)
        
        if newTime < 0 {
            newTime = 0
        }
        let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        player.seek(to: time2)
    }
    
    func returnFromBeginning() {
        player.seek(to: .zero)
    }
    
    func setSpeed(speed: PlayingSpeed) {
        switch speed {
        case .slow:
            player.playImmediately(atRate: 0.7)
        case .normal:
            player.playImmediately(atRate: 1)
        case .quick:
            player.playImmediately(atRate: 1.5)
        }
    }
    
    func skipTo(value: Double) {
        if let duration = self.player.currentItem?.duration.seconds {
            let time = CMTime(seconds: duration * value, preferredTimescale: 1)
            player.seek(to: time)
        }
    }
}
