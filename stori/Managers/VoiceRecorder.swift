//
//  VoiceRecorder.swift
//  stori
//
//  Created by Alex on 29.01.2021.
//

import Foundation
import AVFoundation

class VoiceRecorder {
    
    var audioRecorder: AVAudioRecorder
    var recordingSession: AVAudioSession
    
    var canRecord: Bool
    var waveForm: ((Float) -> Void)?
    private var audioFilename: URL?
    private var waveTimer: Timer?
    
    init() {
        recordingSession = AVAudioSession.sharedInstance()
        canRecord = false
        audioRecorder = AVAudioRecorder()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission { [unowned self] allowed in
                DispatchQueue.main.async {
                    self.canRecord = allowed
                }
            }
        } catch {
            canRecord = false
        }
    }
    
    func startRecording() {
        audioFilename = getDocumentsDirectory().appendingPathComponent("\(String.uniqueName).m4a")
        guard let audioFilename = audioFilename else { return }
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self as? AVAudioRecorderDelegate
            audioRecorder.record()
            audioRecorder.isMeteringEnabled = true
            waveTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                self.audioRecorder.updateMeters()
//                let lowerLimit: Float = -100
                let power = self.audioRecorder.averagePower(forChannel: 0)
                let currentAmplitude = 1 - pow(10, power / 20)
                self.waveForm?(currentAmplitude)
                // This was used for Teacher Section
//                self.waveForm?(exp((power - lowerLimit) * 0.075))
                
            }
        } catch {
            stopRecording(success: false)
            self.audioFilename = nil
            waveTimer?.invalidate()
        }
    }
    
    func stopRecording(success: Bool = true) {
        audioRecorder.stop()
        waveTimer?.invalidate()
    }
    
    func getRecordedAudio() -> URL? {
        return audioFilename
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0]
    }
}
