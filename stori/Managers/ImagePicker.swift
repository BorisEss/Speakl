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
                          completion: @escaping (_ file: UploadedFile) -> Void) {
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
    
//    static func pickVideo(from screen: ImagePickerScreen?) {
//        pick(screen: .library)
//    }
    
    private static func pick(screen: YPPickerScreen?,
                             frontCamera: Bool,
                             completion: @escaping (_ file: UploadedFile) -> Void) {
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
            if let screen = screen,
               screen != .video,
               let photo = items.singlePhoto {
                completion(UploadedFile(id: "", data: Data(), image: photo.image, name: String.uniqueName))
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        UIApplication.getTopViewController()?.present(picker, animated: true, completion: nil)
    }
}
