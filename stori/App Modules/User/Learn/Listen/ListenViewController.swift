//
//  ListenViewController.swift
//  stori
//
//  Created by Alex on 12.01.2022.
//

import UIKit
import TagListView

enum PlayingSpeed {
    case slow
    case normal
    case quick
}

class ListenViewController: UIViewController {

    lazy var completion: (() -> Void)? = nil
    
    private var playingSpeed: PlayingSpeed = .normal {
        didSet {
            UIView.animate(withDuration: 0.3) { [self] in
                slowSpeedButton.borderWidth = playingSpeed == .slow ? 2 : 0
                normalSpeedButton.borderWidth = playingSpeed == .normal ? 2 : 0
                quickSpeedButton.borderWidth = playingSpeed == .quick ? 2 : 0
            }
        }
    }
    
    private var player: AudioPlayer = AudioPlayer()
    
    @IBOutlet weak var speedButtonsView: UIStackView!
    @IBOutlet weak var slowSpeedButton: UIButton!
    @IBOutlet weak var normalSpeedButton: UIButton!
    @IBOutlet weak var quickSpeedButton: UIButton!
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var languageSwitch: UISwitch!
    
    @IBOutlet weak var timelineSlider: UISlider!
    @IBOutlet weak var minTimeSliderLabel: UILabel!
    @IBOutlet weak var maxTimeSliderLabel: UILabel!
    
    @IBOutlet weak var nativeLanguageTextView: UITextView!
    @IBOutlet weak var learningLanguageView: TagListView!
    
    @IBOutlet weak var startButton: StoryLearningButton!
    @IBOutlet weak var restartButton: StoryLearningButton!
    @IBOutlet weak var playingView: UIView!
    @IBOutlet weak var finishButton: StoryLearningButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timelineSlider.setThumbImage(UIImage(named: "slider_thumb_enabled"), for: .normal)
        timelineSlider.setThumbImage(UIImage(named: "slider_thumb_disabled"), for: .disabled)
        timelineSlider.setThumbImage(UIImage(named: "slider_thumb_enabled"), for: .highlighted)
        timelineSlider.isEnabled = false
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.modalPresentationCapturesStatusBarAppearance = true
        learningLanguageView.delegate = self
        learningLanguageView.textFont = .IBMPlexSans(size: 14)
        learningLanguageView.addTags(["Christstollen", "ist", "ein", "Weihnachtskuchen", "Er",
                                      "hat", "eine", "lange", "Tradition", "und", "besteht", "aus", "Hefeteig",
                                      "Zucker", "Gewürzen", "und", "Trockenfrüchten"])
        
        if let url = Bundle.main.url(forResource: "The_Californian_s_Tale_-_By_Mark_Twain",
                                     withExtension: ".mp3") {
            player.load(url: url)
            player.didUpdateProgress = { value in
                self.timelineSlider.value = Float(value)
            }
            player.didReturnTime = { minTime, maxTime in
                self.minTimeSliderLabel.text = minTime
                self.maxTimeSliderLabel.text = maxTime
            }
            player.didFinishPlaying = { [self] in
                startButton.isHidden = true
                restartButton.isHidden = false
                playingView.isHidden = true
                speedButtonsView.isHidden = true
                finishButton.isHidden = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                minTimeSliderLabel.text = player.minTime
                maxTimeSliderLabel.text = player.maxTime
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = .black.withAlphaComponent(0.6)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        cardView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        player.stop()
        view.backgroundColor = .clear
        completion?()
        dismiss(animated: true)
    }
    
    @IBAction func slowSpeedButtonPressed(_ sender: Any) {
        playingSpeed = .slow
        player.setSpeed(speed: .slow)
    }
    @IBAction func normalSpeedButtonPressed(_ sender: Any) {
        playingSpeed = .normal
        player.setSpeed(speed: .normal)
    }
    @IBAction func quickSpeedButtonPressed(_ sender: Any) {
        playingSpeed = .quick
        player.setSpeed(speed: .quick)
    }
    
    @IBAction func languageSwitchChanged(_ sender: UISwitch) {
        UIView.transition(from: sender.isOn ? nativeLanguageTextView : learningLanguageView,
                          to: sender.isOn ? learningLanguageView : nativeLanguageTextView,
                          duration: 0.3,
                          options: [.transitionCrossDissolve, .showHideTransitionViews]) { _ in }
    }
    
    @IBAction func timelineSliderChanged(_ sender: UISlider) {
        player.skipTo(value: Double(sender.value))
        if !finishButton.isHidden {
            startButton.isHidden = false
            restartButton.isHidden = true
            playingView.isHidden = true
            speedButtonsView.isHidden = true
            finishButton.isHidden = true
        }
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        timelineSlider.isEnabled = true
        startButton.isHidden = true
        restartButton.isHidden = false
        playingView.isHidden = false
        speedButtonsView.isHidden = false
        finishButton.isHidden = true
        learningLanguageView.isHidden = false
        player.play()
        startButton.setTitle("Continue", for: .normal)
    }
    
    @IBAction func restartButtonPressed(_ sender: Any) {
        player.returnFromBeginning()
        if !player.isPlaying {
            startButton.setTitle("Start", for: .normal)
        }
        if !player.isPlaying {
            startButton.isHidden = false
            restartButton.isHidden = true
            playingView.isHidden = true
            speedButtonsView.isHidden = true
            finishButton.isHidden = true
        }
    }
    
    @IBAction func goBack2SecondsPressed(_ sender: Any) {
        player.skipBackward()
    }
    
    @IBAction func pauseButtonPressed(_ sender: Any) {
        startButton.isHidden = false
        restartButton.isHidden = true
        playingView.isHidden = true
        speedButtonsView.isHidden = true
        finishButton.isHidden = true
        player.pause()
    }
    
    @IBAction func goNext2SecondsPressed(_ sender: Any) {
        player.skipForward()
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        view.backgroundColor = .clear
        completion?()
        dismiss(animated: true)
    }
    
}

extension ListenViewController: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "WordExplanation", bundle: nil)
        let nextScreen = storyBoard.instantiateViewController(withIdentifier: "SelectedWordViewController")
        if let unwrappedNextScreen = nextScreen as? SelectedWordViewController {
//            unwrappedNextScreen.hashtag = Hashtag(name: hashtag, popularity: 0)
            
            self.navigationController?.pushViewController(unwrappedNextScreen, animated: true)
        }
    }
}
