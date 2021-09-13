//
//  StoryVideoViewController.swift
//  stori
//
//  Created by Alex on 19.08.2021.
//

import UIKit
import AVKit

class StoryVideoViewController: UIViewController {

    var player: AVPlayer = AVPlayer()
    
    var video: Video?
    
    @IBOutlet weak var videoView: UIView!
    
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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let video = video else { return }
        titleLabel.text = video.title
        let asset = AVAsset(url: URL(string: video.sources)!)
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        DispatchQueue.main.async {
            playerLayer.frame = self.videoView.frame
        }
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.backgroundColor = UIColor.black.cgColor
        self.videoView.layer.addSublayer(playerLayer)
        print("play: \(video.sources)")
        player.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
        guard let video = video else { return }
        print("pause: \(video.sources)")
    }
    
    @IBAction func userPressed(_ sender: Any) {
        // TODO: Open user page
        let vcc = UIViewController()
        vcc.view.backgroundColor = .white
        self.navigationController?.pushViewController(vcc, animated: true)
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
        let vcc = UIViewController()
        vcc.view.backgroundColor = .white
        present(vcc, animated: true, completion: nil)
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
        // TODO: Open Listen controller
        let vcc = UIViewController()
        vcc.view.backgroundColor = .white
        present(vcc, animated: true, completion: nil)
        listenButton.inProgress()
    }
    
    @IBAction func readPressed(_ sender: Any) {
        // TODO: Open Read controller
        let vcc = UIViewController()
        vcc.view.backgroundColor = .white
        present(vcc, animated: true, completion: nil)
        readButton.inProgress()
    }
    
    @IBAction func writePressed(_ sender: Any) {
        // TODO: Open Write controller
        let vcc = UIViewController()
        vcc.view.backgroundColor = .white
        present(vcc, animated: true, completion: nil)
        writeButton.inProgress()
    }
    
    @IBAction func speakPressed(_ sender: Any) {
        // TODO: Open Speak controller
        let vcc = UIViewController()
        vcc.view.backgroundColor = .white
        present(vcc, animated: true, completion: nil)
        speakButton.inProgress()
    }
    
    func setVideo(video: Video) {
        self.video = video
    }
}
