//
//  StoryVideoViewController.swift
//  stori
//
//  Created by Alex on 19.08.2021.
//

import UIKit
import AVKit
import KILabel
import SPPermissions

class StoryVideoViewController: UIViewController {
    
    var video: Video?
    
    @IBOutlet weak var videoView: VideoPlayerView!
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var tagListView: UIStackView!
    @IBOutlet weak var newTagView: UIView!
    @IBOutlet weak var inProgressTagView: UIView!
    @IBOutlet weak var completedTagView: UIView!
    @IBOutlet weak var premiumTagView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var studentsLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userBadgeView: UIView!
    @IBOutlet weak var userBadgeIconView: UIImageView!
    
    @IBOutlet weak var shareCountLabel: UILabel!
    
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var commentsIconView: UIImageView!
    @IBOutlet weak var commentsCountLabel: UILabel!
    
    @IBOutlet weak var likesView: UIView!
    @IBOutlet weak var likesIconView: UIImageView!
    @IBOutlet weak var likesCountLabel: UILabel!
    
    @IBOutlet weak var detailsLabel: UILabel!
    
    @IBOutlet weak var hashtagsLabel: KILabel!
    
    @IBOutlet weak var listenSection: UIStackView!
    @IBOutlet weak var listenButton: StoryLearningButton!
    @IBOutlet weak var listenPercentageLabel: UILabel!
    
    @IBOutlet weak var readSection: UIStackView!
    @IBOutlet weak var readButton: StoryLearningButton!
    @IBOutlet weak var readPercentageLabel: UILabel!
    
    @IBOutlet weak var writeSection: UIStackView!
    @IBOutlet weak var writeButton: StoryLearningButton!
    @IBOutlet weak var writePercentageLabel: UILabel!
    
    @IBOutlet weak var speakSection: UIStackView!
    @IBOutlet weak var speakButton: StoryLearningButton!
    @IBOutlet weak var speakPercentageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoView.muteChanged = { isMuted in
            learnTabIsMuted = isMuted
        }
        
        hashtagsLabel.hashtagLinkTapHandler = { _, hashtag, _ in
            let storyBoard: UIStoryboard = UIStoryboard(name: "Learn", bundle: nil)
            let nextScreen = storyBoard.instantiateViewController(withIdentifier: "HashtagVideoListViewController")
            if let unwrappedNextScreen = nextScreen as? HashtagVideoListViewController {
                unwrappedNextScreen.hashtag = Hashtag(name: hashtag, popularity: 0)
                self.navigationController?.pushViewController(unwrappedNextScreen, animated: true)
            }
        }
        inProgressTagView.isHidden = true
        completedTagView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let video = video else { return }
        titleLabel.text = video.title
        videoView.isHidden = video.sources == nil
        coverImageView.isHidden = video.sources != nil
        if let videoSource = video.sources {
            videoView.load(url: videoSource,
                           isMuted: learnTabIsMuted,
                           autoReplay: true,
                           muteAction: true)
            print("play: \(videoSource)")
        } else {
            coverImageView.load(stringUrl: video.cover)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if video?.sources != nil {
            videoView.pause()
        }
        guard let video = video else { return }
        print("pause: \(video.sources ?? "(nil)")")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVc = segue.destination as? UINavigationController,
           let firstVc = nextVc.viewControllers.first as? ReadViewController {
            firstVc.completion = {
                if self.video?.sources != nil {
                    self.videoView.play()
                }
            }
        }
        
        if let nextVc = segue.destination as? UINavigationController,
           let firstVc = nextVc.viewControllers.first as? ListenViewController {
            firstVc.completion = {
                if self.video?.sources != nil {
                    self.videoView.play()
                }
            }
        }
        
        if let nextVc = segue.destination as? UINavigationController,
           let firstVc = nextVc.viewControllers.first as? WritingViewController {
            firstVc.completion = {
                if self.video?.sources != nil {
                    self.videoView.play()
                }
            }
        }
        
        if let nextVc = segue.destination as? UINavigationController,
           let firstVc = nextVc.viewControllers.first as? SpeakViewController {
            firstVc.completion = {
                if self.video?.sources != nil {
                    self.videoView.play()
                }
            }
        }
        super.prepare(for: segue, sender: sender)
    }
    
    @IBAction func userPressed(_ sender: Any) {
        // TODO: Open user page
        let storyBoard: UIStoryboard = UIStoryboard(name: "UserProfile", bundle: nil)
        let nextScreen = storyBoard.instantiateViewController(withIdentifier: "UserProfileViewController")
        if let unwrappedNextScreen = nextScreen as? UserProfileViewController {
            self.navigationController?.pushViewController(unwrappedNextScreen, animated: true)
        }
    }
    
    @IBAction func userBadgePressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            if self.userBadgeView.backgroundColor == .white {
                self.userBadgeView.backgroundColor = UIColor(named: "Tag Green")
                self.userBadgeIconView.image = UIImage(named: "check_mark_white")
            } else {
                self.userBadgeView.backgroundColor = .white
                self.userBadgeIconView.image = UIImage(named: "plus")
            }
        }
        // TODO: Request follow/unfollow user
    }
    
    @IBAction func sharePressed(_ sender: Any) {
//        if let textToShare = Utility.getReferalMessage() {
            let activityViewController = UIActivityViewController(activityItems: [""],
                                                                  applicationActivities: nil)
            activityViewController.excludedActivityTypes = [
                .addToReadingList,
                .airDrop,
                .assignToContact,
                .markupAsPDF,
                .openInIBooks,
                .saveToCameraRoll,
                .print
            ]
            activityViewController.completionWithItemsHandler = { _, completed, _, _ in
                if completed {
//                    VaultPresenter.shareItem(item: item)
//                        .done { _ in
//                            Toast.success(message: "VaultVC_ShareMessage".localized)
//                            self.tableView.loadData(refresh: true)
//                        }
//                        .cauterize()
                }
            }
            self.present(activityViewController, animated: true, completion: nil)
            Vibration().light()
//        } else {
//            Toast.error(message: "AUTHORIZATION_ERROR".localized)
//        }
    }
    
    @IBAction func commentsPressed(_ sender: Any) {
        // TODO: Finish comments view
        let storyBoard: UIStoryboard = UIStoryboard(name: "Comments", bundle: nil)
        let nextScreen = storyBoard.instantiateViewController(withIdentifier: "CommentsViewController")
        if let unwrappedNextScreen = nextScreen as? CommentsViewController {
            unwrappedNextScreen.isModalInPresentation = true
            self.present(unwrappedNextScreen, animated: true)
        }
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        Vibration().light()

        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.curveEaseIn]) {
            self.likesView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.25,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 5,
                       options: [.curveEaseOut]) {
            self.likesView.transform = CGAffineTransform(rotationAngle: CGFloat(2 * Double.pi))
        }
        
        UIView.animate(withDuration: 0.6) {
            if self.likesView.backgroundColor == .white {
                self.likesView.backgroundColor = .gradientTop
                self.likesIconView.tintColor = .white
            } else {
                self.likesView.backgroundColor = .white
                self.likesIconView.tintColor = .gradientTop
            }
        }
        
        // TODO: Like action
    }
    
    @IBAction func listenPressed(_ sender: Any) {
        if video?.sources != nil {
            videoView.pause()
        }
        // TODO: Open Listen controller
//        let vcc = UIViewController()
//        vcc.view.backgroundColor = .white
//        present(vcc, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            listenButton.finished()
            listenPercentageLabel.text = "100%"
        }
    }
    
    @IBAction func readPressed(_ sender: Any) {
        if video?.sources != nil {
            videoView.pause()
        }
        // TODO: Open Read controller
//        let vcc = UIViewController()
//        vcc.view.backgroundColor = .white
//        present(vcc, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            readButton.finished()
            readPercentageLabel.text = "100%"
        }
    }
    
    @IBAction func writePressed(_ sender: Any) {
        if video?.sources != nil {
            videoView.pause()
        }
        // TODO: Open Write controller
//        let vcc = UIViewController()
//        vcc.view.backgroundColor = .white
//        present(vcc, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            writeButton.finished()
            writePercentageLabel.text = "100%"
        }
    }
    
    @IBAction func speakPressed(_ sender: Any) {
        if video?.sources != nil {
            videoView.pause()
        }
        if SPPermissions.Permission.microphone.status != .authorized ||
            SPPermissions.Permission.speech.status != .authorized {
            let permissions: [SPPermissions.Permission] = [.microphone, .speech]
            let controller = SPPermissions.list(permissions)
            controller.showCloseButton = true
            controller.allowSwipeDismiss = true
            controller.delegate = self
            controller.dismissCondition = .allPermissionsAuthorized
            controller.present(on: self)
        } else {
            performSegue(withIdentifier: "showSpeak", sender: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                speakButton.finished()
                speakPercentageLabel.text = "100%"
            }
        }
        // TODO: Open Speak controller
//        let vcc = UIViewController()
//        vcc.view.backgroundColor = .white
//        present(vcc, animated: true, completion: nil)
        
    }
    
    func setVideo(video: Video) {
        self.video = video
    }
}

extension StoryVideoViewController: SPPermissionsDelegate {
    func didHidePermissions(_ permissions: [SPPermissions.Permission]) {
        if permissions.filter({ $0.status != .authorized }).isEmpty {
            performSegue(withIdentifier: "showSpeak", sender: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                speakButton.finished()
                speakPercentageLabel.text = "100%"
            }
        } else {
            var pickerAlertController: UIAlertController
            // TODO: - Update language titles
            pickerAlertController = UIAlertController(title: "Lack of permissions",
                                                      message: "You haven't gave the necessary perrmissions to get access, without them you can't continue to \"Speak\" section." +
                                                      " Please give us these permissions then try again.",
                                                      preferredStyle: .alert)
            let okAction = UIAlertAction(title: "I got it!", style: .cancel) { _ in }
            pickerAlertController.addAction(okAction)
            self.present(pickerAlertController, animated: true)
        }
    }
}
