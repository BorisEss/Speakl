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

    // MARK: - Variables
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
    
    var words: [String] = ["When", "I", "was", "young,", "I", "went", "looking", "for", "gold",
                           "in", "California.", "I", "never", "found", "enough", "to", "make", "me",
                           "rich.", "But", "I", "did", "discover", "a", "beautiful", "part", "of", "the",
                           "country.", "It", "was", "called", "“the", "Stanislau.”", "The", "Stanislau",
                           "was", "like", "Heaven", "on", "Earth.", "It", "had", "bright", "green", "hills",
                           "and", "deep", "forests", "where", "soft", "winds", "touched", "the", "trees."]
    
    // MARK: - IBOutlets
    @IBOutlet weak var speedButtonsView: UIStackView!
    @IBOutlet weak var slowSpeedButton: UIButton!
    @IBOutlet weak var normalSpeedButton: UIButton!
    @IBOutlet weak var quickSpeedButton: UIButton!
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var activityIndicator: AppActivityIndicator!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var languageSwitch: UISwitch!
    
    @IBOutlet weak var timelineSlider: UISlider!
    @IBOutlet weak var minTimeSliderLabel: UILabel!
    @IBOutlet weak var maxTimeSliderLabel: UILabel!
    
    @IBOutlet weak var nativeLanguageTextView: UITextView!
    
    @IBOutlet weak var learningLanguageCollectionView: UICollectionView!
    @IBOutlet weak var startButton: StoryLearningButton!
    @IBOutlet weak var restartButton: StoryLearningButton!
    @IBOutlet weak var playingView: UIView!
    @IBOutlet weak var finishButton: StoryLearningButton!
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        timelineSlider.setThumbImage(UIImage(named: "slider_thumb_enabled"), for: .normal)
        timelineSlider.setThumbImage(UIImage(named: "slider_thumb_disabled"), for: .disabled)
        timelineSlider.setThumbImage(UIImage(named: "slider_thumb_enabled"), for: .highlighted)
        timelineSlider.isEnabled = false
        
        let columnLayout = TopLeftCellsFlowLayout()
        columnLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        columnLayout.minimumInteritemSpacing = 10
        columnLayout.minimumLineSpacing = 10
        columnLayout.footerReferenceSize = CGSize(width: learningLanguageCollectionView.bounds.width, height: 24)
        learningLanguageCollectionView.collectionViewLayout = columnLayout
        learningLanguageCollectionView.register(WordCollectionViewCell.nib(),
                                                forCellWithReuseIdentifier: WordCollectionViewCell.identifier)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.modalPresentationCapturesStatusBarAppearance = true

        if let url = Bundle.main.url(forResource: "paragraph",
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
        
//        activityIndicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = .black.withAlphaComponent(0.6)
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            self.words = ["When", "I", "was", "young,", "I", "went", "looking", "for", "gold",
//                     "in", "California.", "I", "never", "found", "enough", "to", "make", "me",
//                     "rich.", "But", "I", "did", "discover", "a", "beautiful", "part", "of", "the",
//                     "country.", "It", "was", "called", "“the", "Stanislau.”", "The", "Stanislau",
//                     "was", "like", "Heaven", "on", "Earth.", "It", "had", "bright", "green", "hills",
//                     "and", "deep", "forests", "where", "soft", "winds", "touched", "the", "trees."]
//            self.learningLanguageCollectionView.reloadData()
//            self.activityIndicator.stopAnimating()
//        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        cardView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Button Actions
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
        UIView.transition(from: sender.isOn ? nativeLanguageTextView : learningLanguageCollectionView,
                          to: sender.isOn ? learningLanguageCollectionView : nativeLanguageTextView,
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
        languageSwitch.setOn(true, animated: true)
        languageSwitchChanged(languageSwitch)
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
        timelineSlider.isEnabled = false
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

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ListenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return words.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: WordCollectionViewCell.identifier,
                                                          for: indexPath)
        if let cell = mainCell as? WordCollectionViewCell {
            cell.setUp(word: words[indexPath.item])
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.main.scale
            return cell
        }
        return mainCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "WordExplanation", bundle: nil)
        let nextScreen = storyBoard.instantiateViewController(withIdentifier: "SelectedWordViewController")
        if let unwrappedNextScreen = nextScreen as? SelectedWordViewController {
//            unwrappedNextScreen.hashtag = Hashtag(name: hashtag, popularity: 0)
            self.navigationController?.pushViewController(unwrappedNextScreen, animated: true)
        }
    }
    
}
