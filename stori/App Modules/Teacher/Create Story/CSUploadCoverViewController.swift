//
//  CSUploadCoverViewController.swift
//  stori
//
//  Created by Alex on 15.09.2021.
//

import UIKit
import NVActivityIndicatorView

enum CSUploadCoverState {
    case empty
    case uploadingImage
    case uploadingVideo
    case finishedImage
    case finishedVideo
}

class CSUploadCoverViewController: UIViewController {
    
    lazy var cover = CreateStoryObject.shared?.chapter?.cover
        
    var state: CSUploadCoverState = .empty {
        didSet {
            switch state {
            case .empty:
                removeButton.isHidden = true
                coverImageView.isHidden = true
                coverVideoView.isHidden = true
                chooseCoverStackView.isHidden = false
                uploadIconView.isHidden = false
                uploadingActivityIndicatorView.isHidden = true
                uploadingActivityIndicator.stopAnimating()
                coverActionButton.setTitle("Upload Cover", for: .normal)
                coverActionButton.isHidden = false
                coverButtonDescription.isHidden = false
                coverButtonDescription.text = "Static image or video\n720x1280 resolution or higher\nUp to 30 seconds"
            case .uploadingImage:
                removeButton.isHidden = true
                coverImageView.isHidden = false
                coverImageView.alpha = 0.1
                coverVideoView.isHidden = true
                chooseCoverStackView.isHidden = false
                uploadIconView.isHidden = true
                uploadingActivityIndicatorView.isHidden = false
                uploadingActivityIndicator.startAnimating()
                coverButtonDescription.isHidden = true
                coverButtonDescription.text = "Please wait until upload is finished"
            case .uploadingVideo:
                removeButton.isHidden = true
                coverImageView.isHidden = true
                coverVideoView.isHidden = false
                coverVideoView.alpha = 0.1
                chooseCoverStackView.isHidden = false
                uploadIconView.isHidden = true
                uploadingActivityIndicatorView.isHidden = false
                uploadingActivityIndicator.startAnimating()
                coverButtonDescription.isHidden = true
                coverButtonDescription.text = "Please wait until upload is finished"
            case .finishedImage:
                removeButton.isHidden = false
                coverImageView.isHidden = false
                coverImageView.alpha = 1
                coverVideoView.isHidden = true
                chooseCoverStackView.isHidden = true
                uploadingActivityIndicator.stopAnimating()
            case .finishedVideo:
                removeButton.isHidden = false
                coverVideoView.isHidden = false
                coverVideoView.alpha = 1
                coverImageView.isHidden = true
                chooseCoverStackView.isHidden = true
                uploadingActivityIndicator.stopAnimating()
            }
        }
    }
    
    private var pickedFile: LocalFile?

    @IBOutlet weak var chooseCoverStackView: UIStackView!
    @IBOutlet weak var uploadIconView: UIView!
    @IBOutlet weak var uploadIcon: UIImageView!
    @IBOutlet weak var uploadingActivityIndicatorView: UIView!
    @IBOutlet weak var uploadingActivityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var coverActionButton: UIButton!
    @IBOutlet weak var coverButtonDescription: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var coverVideoView: VideoPlayerView!
    
    @IBOutlet weak var removeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "cs_main_list_cover_title".localized
        
        state = .empty
        
        checkForSavedCover()
    }
    
    private func savePickedMedia() {
        guard let chapterId = CreateStoryObject.shared?.chapter?.id else { return }
        CSPresenter.chapter.updateChapter(chapterId: chapterId,
                                          coverId: pickedFile?.id)
            .done { (chapter) in
                CreateStoryObject.shared?.chapter = chapter
            }
            .cauterize()
    }

    @IBAction func coverActionButtonPressed(_ sender: Any) {
        switch state {
        case .empty:
            let imagePickerController: UIAlertController
            if UIDevice.current.userInterfaceIdiom == .pad {
                imagePickerController = UIAlertController(title: "Choose media type",
                                                          message: nil,
                                                          preferredStyle: .alert)
            } else {
                imagePickerController = UIAlertController(title: "Choose media type",
                                                          message: nil,
                                                          preferredStyle: .actionSheet)
            }
            
            let cancelAction = UIAlertAction(title: "common_cancel_title".localized, style: .cancel) { _ in }
            imagePickerController.addAction(cancelAction)
            
            let imageAction = UIAlertAction(title: "Image", style: .default) { _ in
                ImagePicker.pickImage { file in
                    self.pickedFile = file
                    self.coverImageView.image = file.image
                    self.state = .uploadingImage
                    file.upload()
                    file.finishedUpload = { fileId in
                        self.state = .finishedImage
                        self.savePickedMedia()
                    }
                }
            }
            imagePickerController.addAction(imageAction)
            let videoAction = UIAlertAction(title: "Video", style: .default) { _ in
                ImagePicker.pickVideo(from: .library, completion: { file in
                    self.pickedFile = file
                    self.coverImageView.image = file.image
                    self.state = .uploadingVideo
                    file.upload()
                    file.finishedUpload = { fileId in
                        self.state = .finishedVideo
                        self.savePickedMedia()
                        self.coverImageView.isHidden = true
                        self.coverVideoView.load(file: file)
                        self.coverVideoView.play()
                    }
                })
            }
            imagePickerController.addAction(videoAction)
            self.present(imagePickerController, animated: true)
        case .uploadingImage, .uploadingVideo, .finishedImage, .finishedVideo:
            break
        }
    }
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        pickedFile = nil
        state = .empty
        savePickedMedia()
    }
    
    private func checkForSavedCover() {
        guard let cover = cover else {
            return
        }
    }
}
