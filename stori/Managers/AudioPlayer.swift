//
//  AudioPlayer.swift
//  stori
//
//  Created by Alex on 28.01.2021.
//

import Foundation

import MobileVLCKit

class AudioPlayer {
    
    static let shared = AudioPlayer()
    
    private let player: VLCMediaPlayer
    private var progressTimer: Timer?
    
    var didUpdatePlayPause: ((_ isPlaying: Bool) -> Void)?
    var didUpdateProgress: ((_ progress: Double) -> Void)?
    
    var author: String?
    var title: String?
    var album: String?
    
    var isPlaying: Bool {
        return player.isPlaying
    }
    
    init() {
        player = VLCMediaPlayer()
    }
    
    func load(item: BackgroundAudio) {
        stop()
        guard let url = item.fileUrl else { return }
        let media = VLCMedia(url: url)
        player.media = media
        togglePlayPause()
        author = item.author
        title = item.name
        album = item.album
    }
    
    func stop() {
        author = nil
        title = nil
        album = nil
        player.stop()
        progressTimer?.invalidate()
        progressTimer = nil
    }
    
    func togglePlayPause() {
        if player.isPlaying {
            player.pause()
            progressTimer?.invalidate()
        } else {
            player.play()
            progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                let total = (self.player.remainingTime.intValue * -1) + self.player.time.intValue
                if total != 0 {
                    self.didUpdateProgress?(Double(self.player.time.intValue)/Double(total))
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.didUpdatePlayPause?(self.player.isPlaying)
        }
    }
}
