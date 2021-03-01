//
//  ImagePicker.swift
//  stori
//
//  Created by Alex on 06.01.2021.
//

import Foundation
import YPImagePicker

enum ImagePickerScreen {
    case camera
    case library
}

class ImagePicker {
    static func pickImage(from screen: ImagePickerScreen? = nil,
                          frontCamera: Bool = false,
                          completion: @escaping (_ file: LocalFile) -> Void) {
        if let screen = screen {
            switch screen {
            case .camera:
                pick(screen: .photo,
                     frontCamera: frontCamera,
                     completion: completion)
            case .library:
                pick(screen: .library,
                     frontCamera: frontCamera,
                     completion: completion)
            }
        } else {
            pick(screen: nil,
                 frontCamera: frontCamera,
                 completion: completion)
        }
    }
    
    static func pickVideo(from screen: ImagePickerScreen?,
                          completion: @escaping (_ file: LocalFile) -> Void) {
        pick(screen: .library,
             frontCamera: false,
             isVideo: true,
             completion: completion)
    }
    
    private static func pick(screen: YPPickerScreen?,
                             frontCamera: Bool,
                             isVideo: Bool = false,
                             completion: @escaping (_ file: LocalFile) -> Void) {
        var config = YPImagePickerConfiguration()
        config.isScrollToChangeModesEnabled = false
        config.showsPhotoFilters = false
        config.shouldSaveNewPicturesToAlbum = false
        if let screen = screen {
            config.screens = [screen]
        } else {
            config.screens = [.photo, .library]
        }
        config.showsCrop = .none
        config.showsVideoTrimmer = true
        config.library.mediaType = isVideo ? .video : .photo
        config.video.libraryTimeLimit = .infinity
        config.video.recordingTimeLimit = 30
        config.video.trimmerMaxDuration = 30
        config.targetImageSize = YPImageSize.original
        config.overlayView = UIView()
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.preferredStatusBarStyle = UIStatusBarStyle.default
        config.maxCameraZoomFactor = 1.0
        config.library.isSquareByDefault = false
        config.library.onlySquare = false
        config.onlySquareImagesFromCamera = false
        config.usesFrontCamera = frontCamera
        
        let picker = YPImagePicker(configuration: config)

        picker.didFinishPicking { [unowned picker] items, _ in
            if isVideo {
                if let video = items.singleVideo {
                    completion(LocalFile(videoUrl: video.url.absoluteString,
                                         thumbnail: video.thumbnail))
                }
            } else {
                if let photo = items.singlePhoto {
                    completion(LocalFile(image: photo.image))
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        UIApplication.getTopViewController()?.present(picker, animated: true, completion: nil)
    }
}
