//
//  CSUploadCoverViewController.swift
//  stori
//
//  Created by Alex on 15.09.2021.
//

import UIKit
import SwiftyGif
import NVActivityIndicatorView

enum CSUploadCoverState {
    case empty
    case uploadingImage
    case uploadingVideo
    case finishedImage
    case finishedVideo
}

class CSUploadCoverViewController: UIViewController {
    
    var state: CSUploadCoverState = .empty {
        didSet {
            switch state {
            case .empty:
                removeButton.isHidden = true
                coverImageView.isHidden = true
                coverVideoView.isHidden = true
                chooseCoverStackView.isHidden = false
                uploadIcon.isHidden = false
                uploadingActivityIndicator.isHidden = true
                uploadingActivityIndicator.stopAnimating()
                coverActionButton.isHidden = false
                coverButtonDescription.isHidden = false
                coverButtonDescription.text = "(Image or Video)"
            case .uploadingImage:
                removeButton.isHidden = true
                coverImageView.isHidden = false
                coverImageView.alpha = 0.1
                coverVideoView.isHidden = true
                chooseCoverStackView.isHidden = false
                uploadIcon.isHidden = true
                uploadingActivityIndicator.isHidden = false
                uploadingActivityIndicator.startAnimating()
                coverActionButton.setTitle("Cancel", for: .normal)
                coverButtonDescription.isHidden = false
                coverButtonDescription.text = "Please wait until upload is finished"
            case .uploadingVideo:
                removeButton.isHidden = true
                coverImageView.isHidden = true
                coverVideoView.isHidden = false
                coverVideoView.alpha = 0.1
                chooseCoverStackView.isHidden = false
                uploadIcon.isHidden = true
                uploadingActivityIndicator.isHidden = false
                uploadingActivityIndicator.startAnimating()
                coverActionButton.setTitle("Cancel", for: .normal)
                coverButtonDescription.isHidden = false
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
    @IBOutlet weak var uploadIcon: UIImageView!
    @IBOutlet weak var uploadingActivityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var coverActionButton: UIButton!
    @IBOutlet weak var coverButtonDescription: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var coverVideoView: UIView!
    
    @IBOutlet weak var removeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "cs_main_list_cover_title".localized

        if let gif = try? UIImage(gifName: "uploadIcon.gif") {
            uploadIcon.setGifImage(gif)
        }
        
        state = .empty
        
        // TODO: Remove this line
        Toast.warning("This screen isn't completed, here only UI is ready, functional to upload cover is in progress")
    }

    @IBAction func coverActionButtonPressed(_ sender: Any) {
        switch state {
        case .empty:
            let imagePickerController: UIAlertController
            if UIDevice.current.userInterfaceIdiom == .pad {
                imagePickerController = UIAlertController(title: nil,
                                                          message: nil,
                                                          preferredStyle: .alert)
            } else {
                imagePickerController = UIAlertController(title: nil,
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
                }
            }
            imagePickerController.addAction(imageAction)
            let videoAction = UIAlertAction(title: "Video", style: .default) { _ in
                ImagePicker.pickVideo(from: .library, completion: { file in
                    self.pickedFile = file
                    self.state = .uploadingVideo
                })
            }
            imagePickerController.addAction(videoAction)
            self.present(imagePickerController, animated: true)
        case .uploadingImage:
            state = .finishedImage
        case .uploadingVideo:
            state = .finishedVideo
        case .finishedImage, .finishedVideo:
            break
        }
    }
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        pickedFile = nil
        state = .empty
    }
}
