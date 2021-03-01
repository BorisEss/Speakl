//
//  CSRecordVoiceViewController.swift
//  stori
//
//  Created by Alex on 29.01.2021.
//

import UIKit

class CSRecordVoiceViewController: UIViewController {
    
    var completion: ((URL) -> Void)?
    
    private var timer: Timer?
    private var timeValue: Int = 0 {
        didSet {
            let min: Int = timeValue / 60
            let sec: Int = timeValue % 60
            let minutes = String(format: "%02d", min)
            let seconds = String(format: "%02d", sec)
            timerLabel.text = "\(minutes):\(seconds)"
        }
    }
    
    private var recorder = VoiceRecorder()

    @IBOutlet weak var recordButton: RecordButton!
    @IBOutlet weak var backCircle1View: UIView!
    @IBOutlet weak var backCircle2View: UIView!
    @IBOutlet weak var backCircle3View: UIView!
    @IBOutlet weak var backCirclesViewWidth: NSLayoutConstraint!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var saveButton: RegularButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        recordButton.onClick = {
            self.onRecordButtonClick()
        }
        
        recorder.waveForm = { value in
            UIView.animate(withDuration: 0.1) {
                self.backCirclesViewWidth.constant = CGFloat(value)
                self.backCircle1View.layer.cornerRadius = CGFloat(value / 2)
                self.backCircle2View.layer.cornerRadius = CGFloat(value * 0.75 / 2)
                self.backCircle3View.layer.cornerRadius = CGFloat(value * 0.5 / 2)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        guard let url = recorder.getRecordedAudio() else { return }
        completion?(url)
    }
    
    private func onRecordButtonClick() {
        if recorder.canRecord {
            backCircle1View.isHidden = !recordButton.isRecording
            timerLabel.isHidden = false
            view.layoutIfNeeded()
            if recordButton.isRecording {
                title = "cs_recording_screen_recording_title".localized
                startTimer()
            } else {
                title = "cs_recording_screen_recording_finished_title".localized
                stopTimer()
            }
        } else {
            Toast.error("cs_recording_screen_error_microphone".localized)
            recordButton.isRecording = false
        }
    }
    
    func startTimer() {
        saveButton.isHidden = true
        timeValue = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.timeValue += 1
        }
        recorder.startRecording()
    }
    
    func stopTimer() {
        recorder.stopRecording()
        timer?.invalidate()
        timer = nil
        saveButton.isHidden = false
    }
    
    private func setUpLanguage() {
        title = "cs_recording_screen_main_title".localized
    }
}
