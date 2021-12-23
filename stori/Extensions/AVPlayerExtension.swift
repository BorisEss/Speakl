//
//  AVPlayerExtension.swift
//  stori
//
//  Created by Alex on 18.11.2021.
//

import Foundation
import AVFoundation

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
    
    func clear() {
        self.pause()
        self.replaceCurrentItem(with: nil)
    }
}
