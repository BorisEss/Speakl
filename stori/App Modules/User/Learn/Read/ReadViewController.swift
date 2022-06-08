//
//  ReadViewController.swift
//  stori
//
//  Created by Alex on 27.12.2021.
//

import UIKit
import StepSlider
import TagListView

class ReadViewController: UIViewController {
    
    var paragraphs: [[String]] = [
        ["When", "I", "was", "young,", "I", "went", "looking", "for", "gold", "in", "California."],
        ["I", "never", "found", "enough", "to", "make", "me", "rich."],
        ["But", "I", "did", "discover", "a", "beautiful", "part", "of", "the", "country."],
        ["It", "was", "called", "“the", "Stanislau.”"],
        ["The", "Stanislau", "was", "like", "Heaven", "on", "Earth."],
        ["It", "had", "bright", "green", "hills", "and", "deep", "forests", "where", "soft",
         "winds", "touched", "the", "trees."]
    ]
    var currentParagraph: Int = 0 {
        didSet {
            if paragraphs.count == 0 {
                previousButton.isHidden = true
                nextButton.isHidden = true
                finishButton.isHidden = true
            } else if paragraphs.count == 1 {
                previousButton.isHidden = true
                nextButton.isHidden = true
                finishButton.isHidden = false
            } else {
                if currentParagraph == 0 {
                    previousButton.isHidden = true
                    nextButton.isHidden = false
                    finishButton.isHidden = true
                } else if currentParagraph == paragraphs.count - 1 {
                    previousButton.isHidden = false
                    nextButton.isHidden = true
                    finishButton.isHidden = false
                } else {
                    previousButton.isHidden = false
                    nextButton.isHidden = false
                    finishButton.isHidden = true
                }
            }
            pageLabel.text = "\(currentParagraph + 1) of \(paragraphs.count)"
            pageSlider.setIndex(UInt(currentParagraph), animated: true)
            learningLanguageWordsView.removeAllTags()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.learningLanguageWordsView.addTags(self.paragraphs[self.currentParagraph])
            }
        }
    }
    
    lazy var completion: (() -> Void)? = nil

    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var languageSwitch: UISwitch!
    
    @IBOutlet weak var nativeLanguageView: UIStackView!
    @IBOutlet weak var nativeLanguageTextView: UITextView!
    
    @IBOutlet weak var learningLanguageView: UIStackView!
    @IBOutlet weak var learningLanguageWordsView: TagListView!
    @IBOutlet weak var previousButton: StoryLearningButton!
    @IBOutlet weak var nextButton: StoryLearningButton!
    @IBOutlet weak var finishButton: StoryLearningButton!
    
    @IBOutlet weak var pageSectionView: UIStackView!
    
    @IBOutlet weak var pageSlider: StepSlider!
    @IBOutlet weak var pageLabel: UILabel!
    
    @IBOutlet weak var paragraphView: UIView!
    @IBOutlet weak var paragraphLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.modalPresentationCapturesStatusBarAppearance = true
        currentParagraph = 0
        pageSlider.maxCount = UInt(paragraphs.count)
        learningLanguageWordsView.delegate = self
        learningLanguageWordsView.textFont = .IBMPlexSans(size: 14)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = .black.withAlphaComponent(0.6)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        UIView.animate(withDuration: 0.3) {
//            self.view.backgroundColor = .clear
//        }
//        completion?()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        cardView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        view.backgroundColor = .clear
        completion?()
        dismiss(animated: true)
    }
    
    @IBAction func languageSwitchChanged(_ sender: UISwitch) {
        UIView.transition(from: sender.isOn ? nativeLanguageView : learningLanguageView,
                          to: sender.isOn ? learningLanguageView : nativeLanguageView,
                          duration: 0.3,
                          options: [.transitionCrossDissolve, .showHideTransitionViews]) { _ in }
    }
    
    @IBAction func previousButtonPressed(_ sender: Any) {
        currentParagraph -= 1
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        currentParagraph += 1
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        view.backgroundColor = .clear
        completion?()
        dismiss(animated: true)
    }
    
    @IBAction func pageSliderBegin(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.paragraphView.alpha = 1
        }
    }
    
    @IBAction func pageSliderChanged(_ sender: StepSlider) {
        Vibration().light()
        // TODO: Update language translation
        paragraphLabel.text = "Paragraph #\(sender.index + 1)"
    }
    
    @IBAction func pageSliderEnd(_ sender: StepSlider) {
        UIView.animate(withDuration: 0.3) {
            self.paragraphView.alpha = 0
        }
        currentParagraph = Int(sender.index)
    }
}

extension ReadViewController: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "WordExplanation", bundle: nil)
        let nextScreen = storyBoard.instantiateViewController(withIdentifier: "WEViewController")
        if let unwrappedNextScreen = nextScreen as? WEViewController {
//            unwrappedNextScreen.hashtag = Hashtag(name: hashtag, popularity: 0)
            
            self.navigationController?.pushViewController(unwrappedNextScreen, animated: true)
        }
    }
}
