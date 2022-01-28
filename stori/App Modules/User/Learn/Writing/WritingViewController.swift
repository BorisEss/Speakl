//
//  WritingViewController.swift
//  stori
//
//  Created by Alex on 24.01.2022.
//

import UIKit

enum WritingLebel {
    case easy
    case hard
    case expert
}

class WritingViewController: UIViewController {
    
    var words: [WritingWord] = [
        WritingWord(word: "Christstollen", isEmpty: false, wasEmpty: false),
        WritingWord(word: "ist", isEmpty: false, wasEmpty: false),
        WritingWord(word: "ein", isEmpty: false, wasEmpty: false),
        WritingWord(word: "Weihnachtskuchen", isEmpty: false, wasEmpty: false),
        WritingWord(word: "Er", isEmpty: false, wasEmpty: false),
        WritingWord(word: "hat", isEmpty: false, wasEmpty: false),
        WritingWord(word: "eine", isEmpty: false, wasEmpty: false),
        WritingWord(word: "lange", isEmpty: false, wasEmpty: false),
        WritingWord(word: "Tradition", isEmpty: false, wasEmpty: false),
        WritingWord(word: "und", isEmpty: false, wasEmpty: false),
        WritingWord(word: "besteht", isEmpty: false, wasEmpty: false),
        WritingWord(word: "aus", isEmpty: false, wasEmpty: false),
        WritingWord(word: "Hefeteig", isEmpty: false, wasEmpty: false),
        WritingWord(word: "Zucker", isEmpty: false, wasEmpty: false),
        WritingWord(word: "Gewürzen", isEmpty: false, wasEmpty: false),
        WritingWord(word: "und", isEmpty: false, wasEmpty: false),
        WritingWord(word: "Trockenfrüchten", isEmpty: false, wasEmpty: false)
    ]
    
    var level: WritingLebel = .easy {
        didSet {
            var missingWordsCount: Int = 0
            switch level {
            case .easy: missingWordsCount = Int(Double(words.count) * 0.25)
            case .hard: missingWordsCount = Int(Double(words.count) * 0.5)
            case .expert: missingWordsCount = Int(Double(words.count) * 0.75)
            }
            let randomIndexes: [Int] = (0..<words.count).randomElements(missingWordsCount)
            for index in randomIndexes {
                words[index].isEmpty = true
                words[index].wasEmpty = true
            }
            tagsCollectionView.reloadData()
        }
    }
    
    private var player: AudioPlayer = AudioPlayer()
    
    lazy var completion: (() -> Void)? = nil

    @IBOutlet weak var topCardSpacing: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var levelSelectionCardView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var listenView: UIView!
    @IBOutlet weak var listenProgressWidth: NSLayoutConstraint!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var learningLanguageLabel: UILabel!
    
    @IBOutlet weak var nativeLanguageTextView: UITextView!
    @IBOutlet weak var learningLanguageView: UIStackView!
    
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    
    @IBOutlet weak var previousButton: StoryLearningButton!
    @IBOutlet weak var nextButton: StoryLearningButton!
    @IBOutlet weak var finishButton: StoryLearningButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.alpha = 0
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.modalPresentationCapturesStatusBarAppearance = true
        listenProgressWidth.constant = 0
        resetButton.isHidden = true
        
        let columnLayout = TopLeftCellsFlowLayout()
        columnLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        tagsCollectionView.collectionViewLayout = columnLayout

        if let url = Bundle.main.url(forResource: "short_story",
                                     withExtension: ".mp3") {
            player.load(url: url)
            player.didUpdateProgress = { value in
                self.listenProgressWidth.constant = self.listenView.bounds.width * value
            }
            player.didFinishPlaying = { [self] in
                playPauseButton.setImage(UIImage(named: "speaker_circled_icon"), for: .normal)
            }
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
            print(topCardSpacing.constant)
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
        self.listenView.alpha = 0
        self.listenView.isHidden = false
        switch sender.tag {
        case 0: level = .easy
        case 1: level = .hard
        case 2: level = .expert
        default: break
        }
        UIView.animate(withDuration: 0.3) {
            self.topCardSpacing.constant = 80
            self.listenView.alpha = 1
            self.view.layoutSubviews()
        }

        UIView.transition(from: levelSelectionCardView,
                          to: cardView,
                          duration: 0.2, options: [.curveEaseInOut,
                                                   .layoutSubviews,
                                                   .showHideTransitionViews,
                                                   .transitionCrossDissolve]) { _ in }
    }
    
    @IBAction func playPauseButtonPressed(_ sender: Any) {
        if player.isPlaying {
            player.pause()
            playPauseButton.setImage(UIImage(named: "speaker_circled_icon"), for: .normal)
        } else {
            player.play()
            playPauseButton.setImage(UIImage(named: "pause_circled_icon"), for: .normal)
        }
        resetButton.isHidden = false
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        player.returnFromBeginning()
        if !player.isPlaying {
            resetButton.isHidden = true
            listenProgressWidth.constant = 0
        }
    }
    
    @IBAction func learningLanguageSwitchChanged(_ sender: UISwitch) {
        nativeLanguageTextView.isHidden = sender.isOn
        learningLanguageView.isHidden = !sender.isOn
    }
    
    @IBAction func previousButtonPressed(_ sender: Any) {
        nextButton.isHidden = false
        previousButton.isHidden = true
        finishButton.isHidden = true
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        nextButton.isHidden = true
        previousButton.isHidden = false
        finishButton.isHidden = false
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        view.backgroundColor = .clear
        closeButton.alpha = cardView.isHidden ? 0 : 1
        completion?()
        player.stop()
        dismiss(animated: true)
    }
    
    func checkWords() {
        if !words.contains(where: { $0.isEmpty }) {
            nextButton.isHidden = false
        }
    }
}

extension WritingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return words.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WritingCollectionViewCell",
                                                          for: indexPath)
        if let cell = mainCell as? WritingCollectionViewCell {
            cell.setUp(word: words[indexPath.item])
            cell.completion = {
                self.words[indexPath.item].isEmpty = false
                self.checkWords()
            }
            return cell
        }
        return mainCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if player.isPlaying {
            player.pause()
            playPauseButton.setImage(UIImage(named: "speaker_circled_icon"), for: .normal)
        }
        if words[indexPath.item].wasEmpty {
            if let cell = collectionView.cellForItem(at: indexPath) as? WritingCollectionViewCell {
                if cell.state == .correct || cell.state == .incorrect {
                    let controller = UIStoryboard(name: "Writing",
                                                  bundle: nil)
                        .instantiateViewController(withIdentifier: "WritingAlertViewController")
                    if let alertController = controller as? WritingAlertViewController {
                        alertController.word = words[indexPath.item]
                        if cell.state == .incorrect {
                            alertController.itIsCorrect = false
                        }
                        present(alertController, animated: true, completion: nil)
                    }
                }
            }
        } else {
            let storyBoard: UIStoryboard = UIStoryboard(name: "WordExplanation", bundle: nil)
            let nextScreen = storyBoard.instantiateViewController(withIdentifier: "SelectedWordViewController")
            if let unwrappedNextScreen = nextScreen as? SelectedWordViewController {
                //            unwrappedNextScreen.hashtag = Hashtag(name: hashtag, popularity: 0)
                
                self.navigationController?.pushViewController(unwrappedNextScreen, animated: true)
            }
        }
    }
}
