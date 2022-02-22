//
//  SpeakViewController.swift
//  stori
//
//  Created by Alex on 01.02.2022.
//

import UIKit
import MBCircularProgressBar
import Speech
import DSWaveformImage

enum SpeakLevel {
    case oneWord
    case wordByWord
    case sentence
    case paragraph
}

enum SpeakSpeed {
    case slow
    case normal
}

struct SpeakWord {
    var word: String
    var hasAnsweredCorrect: Bool?
}

class SpeakViewController: UIViewController {

    var words: [String] = [
        "When", "I", "was", "young,", "I", "went", "looking", "for", "gold,", "in", "California.",
        "I", "never", "found", "enough", "to", "make", "me", "rich."
    ]
    var speakWords: [SpeakWord] = []
    var sentences: [(audio: String, text: SpeakWord)] = [
        ("sentence1", SpeakWord(word: "When I was young, I went looking for gold in California.")),
        ("sentence2", SpeakWord(word: "I never found enough to make me rich.")),
        ("sentence3", SpeakWord(word: "But I did discover a beautiful part of the country.")),
        ("sentence4", SpeakWord(word: "It was called “the Stanislau.”")),
        ("sentence5", SpeakWord(word: "The Stanislau was like Heaven on Earth.")),
        ("sentence6", SpeakWord(word: "It had bright green hills and deep forests where soft winds touched the trees."))
    ]
    var paragraph = SpeakWord(word: "When I was young, I went looking for gold in California. " +
                            "I never found enough to make me rich. " +
                            "But I did discover a beautiful part of the country. It was called “the Stanislau.” " +
                            "The Stanislau was like Heaven on Earth. " +
                            "It had bright green hills and deep forests where soft winds touched the trees.")
    
    var currentIndex: Int = 0
    
    var level: SpeakLevel = .oneWord {
        didSet {
            collectionView.isHidden = level != .oneWord
            tableView.isHidden = level == .oneWord
            switch level {
            case .oneWord:
                levelTypeLabel.text = "One Word"
                for word in words {
                    speakWords.append(SpeakWord(word: word))
                }
                collectionView.reloadData()
            case .wordByWord:
                levelTypeLabel.text = "Word by word"
                for index in 1...words.count {
                    speakWords.append(SpeakWord(word: words[0..<index].joined(separator: " ")))
                }
                tableView.reloadData()
            case .sentence:
                levelTypeLabel.text = "Full sentence"
                if let url = Bundle.main.url(forResource: sentences[currentIndex].audio, withExtension: ".mp3") {
                    player.load(url: url)
                }
                tableView.reloadData()
            case .paragraph:
                levelTypeLabel.text = "Full paragraph"
                if let url = Bundle.main.url(forResource: "paragraph", withExtension: ".mp3") {
                    player.load(url: url)
                }
                tableView.reloadData()
            }
        }
    }
    
    var speed: SpeakSpeed = .normal {
        didSet {
            normalSpeedButton.borderWidth = speed == .normal ? 3 : 0
            normalSpeedButton.shadowOpacity = speed == .normal ? 1 : 0
            slowSpeedButton.borderWidth = speed == .slow ? 3 : 0
            slowSpeedButton.shadowOpacity = speed == .slow ? 1 : 0
        }
    }
    
    private var player: AudioPlayer = AudioPlayer()
    private var recordingPlayer: AudioPlayer = AudioPlayer()
    let synthesizer = AVSpeechSynthesizer()
    
    private var timer: Timer?
    private var liveIconTimer: Timer?
    private var timeValue: Int = 0 {
        didSet {
            let min: Int = timeValue / 60
            let sec: Int = timeValue % 60
            let minutes = String(format: "%d", min)
            let seconds = String(format: "%02d", sec)
            recordingTimerLabel.text = "\(minutes):\(seconds)"
        }
    }
    
    let recorder = VoiceRecorder()
    
    lazy var completion: (() -> Void)? = nil
    
    @IBOutlet weak var topCardSpacing: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var levelSelectionCardView: UIView!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var levelTypeLabel: UILabel!
    @IBOutlet weak var learningLanguageLabel: UILabel!
    
    @IBOutlet weak var nativeLanguageTextView: UITextView!
    @IBOutlet weak var learningLanguageView: UIStackView!
    
    @IBOutlet weak var normalSpeedButton: UIButton!
    @IBOutlet weak var slowSpeedButton: UIButton!
    @IBOutlet weak var listenButton: UIButton!
    
    @IBOutlet weak var listeningProgressView: MBCircularProgressBarView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var speakButton: StoryLearningButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var recordingView: UIView!
    
    @IBOutlet weak var recordingLeftButton: UIButton!
    @IBOutlet weak var recordingTimerLabel: UILabel!
    @IBOutlet weak var recordingRightEmptyView: UIView!
    @IBOutlet weak var recordingRightButton: UIButton!
    @IBOutlet weak var waveformLiveView: WaveformLiveView!
    @IBOutlet weak var recordingActivityIndicatorMainView: UIView!
    @IBOutlet weak var recordingActivityIndicator: AppActivityIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton.alpha = 0
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.modalPresentationCapturesStatusBarAppearance = true
        
        player.didUpdateProgress = { value in
            UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear]) {
                self.listeningProgressView.value = value * 100
            } completion: { _ in
                
            }
        }
        player.didFinishPlaying = { [self] in
            self.player.returnFromBeginning()
        }
        
        let columnLayout = TopLeftCellsFlowLayout()
        columnLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView.collectionViewLayout = columnLayout
        
        waveformLiveView.configuration = waveformLiveView.configuration
            .with(style: .striped(.init(color: .white,
                                        width: 2,
                                        spacing: 2)),
                  dampening: waveformLiveView.configuration.dampening?.with(percentage: 0),
                  verticalScalingFactor: 0.7
            )
        
        waveformLiveView.shouldDrawSilencePadding = true
        
        recorder.waveForm = { value in
            self.waveformLiveView.add(samples: [value, value, value])
        }
        
        recordingPlayer.didUpdateProgressTime = { time in
            self.timeValue = Int(time)
        }
        
        recordingPlayer.didFinishPlaying = {
            self.recordingLeftButton.setImage(UIImage(named: "play.fill"), for: .normal)
            self.timeValue = 0
            self.recordingPlayer.returnFromBeginning()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !levelSelectionCardView.isHidden {
            UIView.animate(withDuration: 0.3) {
                self.view.backgroundColor = .black.withAlphaComponent(0.6)
            }
            UIView.animate(withDuration: 0.3) {
                self.closeButton.alpha = 1
            }
            topCardSpacing.constant += view.frame.height
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        levelSelectionCardView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
        cardView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        view.backgroundColor = .clear
        closeButton.alpha = cardView.isHidden ? 0 : 1
        completion?()
        player.stop()
        dismiss(animated: true)
    }
    
    @IBAction func levelSelected(_ sender: UIButton) {
        switch sender.tag {
        case 0: level = .oneWord
        case 1: level = .wordByWord
        case 2: level = .sentence
        case 3: level = .paragraph
        default: break
        }
        
        UIView.animate(withDuration: 0.3) {
            self.topCardSpacing.constant = 80
            self.view.layoutSubviews()
        }

        UIView.transition(from: levelSelectionCardView,
                          to: cardView,
                          duration: 0.2, options: [.curveEaseInOut,
                                                   .layoutSubviews,
                                                   .showHideTransitionViews,
                                                   .transitionCrossDissolve]) { _ in }
    }
    
    @IBAction func learningLanguageSwitchChanged(_ sender: UISwitch) {
        nativeLanguageTextView.isHidden = sender.isOn
        learningLanguageView.isHidden = !sender.isOn
    }
    
    @IBAction func normalSpeedButtonPressed(_ sender: Any) {
        speed = .normal
        if player.isPlaying { player.setSpeed(speed: .normal) }
    }
    
    @IBAction func slowSpeedButtonPressed(_ sender: Any) {
        speed = .slow
        if player.isPlaying { player.setSpeed(speed: .slow) }
    }

    @IBAction func listenButtonPressed(_ sender: Any) {
        switch level {
        case .oneWord:
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category.playAndRecord,
                                             mode: .spokenAudio,
                                             options: .defaultToSpeaker)
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            } catch { }
            let wordUtterance = AVSpeechUtterance(string: speakWords[currentIndex].word.lowercased())
            wordUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            if speed == .slow {
                wordUtterance.rate = 0.3
            }
            synthesizer.speak(wordUtterance)
        case .wordByWord:
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category.playAndRecord,
                                             mode: .spokenAudio,
                                             options: .defaultToSpeaker)
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            } catch { }
            let wordUtterance = AVSpeechUtterance(string: speakWords[currentIndex].word)
            wordUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            if speed == .slow {
                wordUtterance.rate = 0.3
            }
            synthesizer.speak(wordUtterance)
        case .sentence, .paragraph:
            if player.isPlaying {
                player.pause()
            } else {
                player.play()
                if speed == .slow {
                    player.setSpeed(speed: .slow)
                } else {
                    player.setSpeed(speed: .normal)
                }
            }
        }
    }
    
    @IBAction func speakButtonPressed(_ sender: Any) {
        if player.isPlaying {
            player.pause()
            player.returnFromBeginning()
        }
        waveformLiveView.reset()
        recordingRightButton.setImage(UIImage(named: "stop.fill"), for: .normal)
        recordingLeftButton.setImage(UIImage(named: "recording_icon"), for: .normal)
        startTimer()
        recordingTimerLabel.text = "0:00"
        speakButton.isHidden = true
        recordingView.isHidden = false
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        speakButton.isHidden = false
        deleteButton.isHidden = true
        recordingView.isHidden = true
    }
    
    @IBAction func recordingLeftButtonPressed(_ sender: UIButton) {
        if sender.image(for: .normal) == UIImage(named: "recording_icon") {
            // Recording button is inactive
        } else if sender.image(for: .normal) == UIImage(named: "play.fill") {
            // Play the recorded file
            recordingPlayer.play()
            recordingLeftButton.setImage(UIImage(named: "pause.fill"), for: .normal)
        } else if sender.image(for: .normal) == UIImage(named: "pause.fill") {
            // Pause the recorded file
            recordingPlayer.pause()
            recordingLeftButton.setImage(UIImage(named: "play.fill"), for: .normal)
        }
    }
    
    @IBAction func recordingRightButtonPressed(_ sender: UIButton) {
        if sender.image(for: .normal) == UIImage(named: "stop.fill") {
            if deleteButton.isHidden { deleteButton.isHidden = false }
            stopTimer()
            recordingLeftButton.setImage(UIImage(named: "play.fill"), for: .normal)
            recordingRightButton.setImage(UIImage(named: "send.fill"), for: .normal)
            guard let file = recorder.getRecordedAudio() else { return }
            recordingPlayer.load(url: file)
            deleteButton.isEnabled = true
        } else if sender.image(for: .normal) == UIImage(named: "send.fill") {
            guard let file = recorder.getRecordedAudio() else { return }
            recordingPlayer.stop()
            recordingLeftButton.setImage(UIImage(named: "play.fill"), for: .normal)
            deleteButton.isEnabled = false
            recordingLeftButton.isEnabled = false
            recordingRightButton.isHidden = true
            recordingActivityIndicatorMainView.isHidden = false
            recordingActivityIndicator.startAnimating()
            recognizeText(file: file) { result in
                switch self.level {
                case .oneWord, .wordByWord:
                    self.checkTexts(initial: self.speakWords[self.currentIndex].word, final: result)
                case .sentence:
                    self.checkTexts(initial: self.sentences[self.currentIndex].1.word, final: result)
                case .paragraph:
                    self.checkTexts(initial: self.paragraph.word, final: result)
                }
            }
        }
    }
    
    func startTimer() {
        timeValue = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.timeValue += 1
        }
        liveIconTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in
            UIView.animate(withDuration: 1) {
                self.recordingLeftButton.alpha = 0.3
            } completion: { _ in
                UIView.animate(withDuration: 1) {
                    self.recordingLeftButton.alpha = 1
                }
            }
        })
        recorder.startRecording()
    }
    
    func stopTimer() {
        recorder.stopRecording()
        timer?.invalidate()
        recordingLeftButton.alpha = 1
        liveIconTimer?.invalidate()
        timer = nil
    }
    
    func recognizeText(file: URL, completion: @escaping ((String) -> Void)) {
        // process recorded file to speech-to-text
        
        guard let myRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US")) else {
            // A recognizer is not supported for the current locale
            return
        }
        
        if !myRecognizer.isAvailable {
            // The recognizer is not available right now
            return
        }
        
        let request = SFSpeechURLRecognitionRequest(url: file)
        myRecognizer.recognitionTask(with: request) { (result, _) in
            guard let result = result else {
                // Recognition failed, so check error for details and handle it
                return
            }
            // Print the speech that has been recognized so far
            if result.isFinal {
                completion(result.bestTranscription.formattedString)
            }
        }
    }
    
    func checkTexts(initial: String, final: String) {
        let initialModified = initial.trimTrailingPunctuation().lowercased()
        let finalModified = final.trimTrailingPunctuation().lowercased()
        
        let isCorrect = initialModified.elementsEqual(finalModified)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Speak", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SpeakAlertViewController")
        guard let controller = newViewController as? SpeakAlertViewController  else { return }
        controller.itIsCorrect = isCorrect
        controller.userText = final
        controller.correctText = initial
        controller.definition = initial
        
        switch level {
        case .oneWord:
            controller.userAudio = recorder.getRecordedAudio()
            controller.itIsLastWord = currentIndex == speakWords.count - 1
            controller.speakAgainCompletionHandler = { [self] in
                collectionView.reloadData()
                deleteButtonPressed(deleteButton)
            }
            controller.nextCompletionHandler = { [self] in
                speakWords[currentIndex].hasAnsweredCorrect = isCorrect
                deleteButtonPressed(deleteButton)
                if currentIndex == speakWords.count - 1 {
                    dismiss(animated: true, completion: nil)
                } else {
                    currentIndex += 1
                }
                collectionView.reloadData()
            }
        case .wordByWord:
            controller.userAudio = recorder.getRecordedAudio()
            controller.itIsLastWord = currentIndex == speakWords.count - 1
            controller.speakAgainCompletionHandler = { [self] in
                tableView.reloadData()
                deleteButtonPressed(deleteButton)
            }
            controller.nextCompletionHandler = { [self] in
                speakWords[currentIndex].hasAnsweredCorrect = isCorrect
                deleteButtonPressed(deleteButton)
                if currentIndex == speakWords.count - 1 {
                    dismiss(animated: true, completion: nil)
                } else {
                    currentIndex += 1
                }
                tableView.reloadData()
            }
        case .sentence:
            controller.userAudio = recorder.getRecordedAudio()
            controller.correctAudio = Bundle.main.url(forResource: sentences[currentIndex].audio, withExtension: ".mp3")
            controller.itIsLastWord = currentIndex == sentences.count - 1
            controller.speakAgainCompletionHandler = { [self] in
                tableView.reloadData()
                deleteButtonPressed(deleteButton)
            }
            controller.nextCompletionHandler = { [self] in
                sentences[currentIndex].text.hasAnsweredCorrect = isCorrect
                deleteButtonPressed(deleteButton)
                if currentIndex == sentences.count - 1 {
                    dismiss(animated: true, completion: nil)
                } else {
                    currentIndex += 1
                    if let url = Bundle.main.url(forResource: sentences[currentIndex].audio, withExtension: ".mp3") {
                        player.load(url: url)
                    }
                }
                tableView.reloadData()
            }
        case .paragraph:
            controller.userAudio = recorder.getRecordedAudio()
            controller.correctAudio = Bundle.main.url(forResource: "paragraph", withExtension: ".mp3")
            controller.itIsLastWord = true
            controller.speakAgainCompletionHandler = { [self] in
                tableView.reloadData()
                deleteButtonPressed(deleteButton)
            }
            controller.nextCompletionHandler = { [self] in
                paragraph.hasAnsweredCorrect = isCorrect
                tableView.reloadData()
                deleteButtonPressed(deleteButton)
                dismiss(animated: true, completion: nil)
            }
        }
        self.present(controller, animated: true) {
            self.recordingRightButton.isHidden = false
            self.recordingActivityIndicatorMainView.isHidden = true
            self.recordingActivityIndicator.stopAnimating()
        }
    }
}

extension SpeakViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch level {
        case .oneWord: return currentIndex + 1
        case .wordByWord: return 0
        case .sentence: return 0
        case .paragraph: return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpeakCollectionViewCell",
                                                          for: indexPath)
        if let cell = mainCell as? SpeakCollectionViewCell {
            switch level {
            case .oneWord:
                cell.setUp(word: speakWords[indexPath.item])
            case .wordByWord, .sentence, .paragraph:
                cell.setUp(word: SpeakWord(word: ""))
            }
            return cell
        }
        return mainCell
    }
}

extension SpeakViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard indexPath.item < speakWords.count else { return CGSize.zero }
        let item = speakWords[indexPath.item].word
        let itemSize = item.size(withAttributes: [
            NSAttributedString.Key.font: UIFont.IBMPlexSansLight(size: 14)
        ])
        return CGSize(width: itemSize.width + 32, height: 32)
    }
}

extension SpeakViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mainCell = tableView.dequeueReusableCell(withIdentifier: "SpeakTableViewCell")
        if let cell = mainCell as? SpeakTableViewCell {
            switch level {
            case .oneWord: break
            case .wordByWord: cell.setUp(word: speakWords[indexPath.item])
            case .sentence: cell.setUp(word: sentences[indexPath.item].text)
            case .paragraph: cell.setUp(word: paragraph)
            }
            return cell
        }
        return mainCell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch level {
        case .oneWord: return 0
        case .wordByWord: return currentIndex + 1
        case .sentence: return currentIndex + 1
        case .paragraph: return 1
        }
    }
}
