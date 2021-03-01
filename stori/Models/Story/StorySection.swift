//
//  StorySection.swift
//  stori
//
//  Created by Alex on 31.01.2021.
//

import UIKit
import PromiseKit

enum StorySectionType {
    case text
    case image
    case video
}

class StorySection {
    var id: Int?
    var type: StorySectionType
    var finishedUpload: Bool
    var didFinishUpload: (() -> Void)?
    
    init(id: Int,
         type: StorySectionType) {
        self.id = id
        self.type = type
        finishedUpload = true
        didFinishUpload?()
    }
    
    init(type: StorySectionType) {
        self.type = type
        self.finishedUpload = false
    }
}

class StorySectionBuilder {
    static func createMediaItem(chapterId: Int, file: LocalFile) -> StorySection? {
        if file.fileType == .video {
            return StoryVideoSection(chapterId: chapterId, type: .video, file: file)
        } else if file.fileType == .image {
            return StoryImageSection(chapterId: chapterId, type: .image, file: file)
        } else {
            return nil
        }
    }
    static func createText(chapterId: Int) -> StorySection {
        return StoryTextSection(text: "", chapterId: chapterId)
    }
    
    static func createItem(model: SectionModel) -> Promise<StorySection> {
        return Promise<StorySection> { promise in
            switch model.type {
            case .text:
                promise.fulfill(StoryTextSection(id: model.id,
                                                 text: model.text,
                                                 words: model.words))
            case .media:
                guard let uploadType = model.uploadType,
                      let uploadFile = model.upload else {
                    promise.reject(NetworkError.notFound)
                    return
                }
                switch uploadType {
                case .video:
                    guard let thumbnail = model.thumbnail else { return }
                    UIImage.downloadImage(url: thumbnail)
                        .done { (image) in
                            let localFile = LocalFile(videoUrl: uploadFile, thumbnail: image)
                            promise.fulfill(StoryVideoSection(id: model.id, type: .video, file: localFile))
                        }
                        .catch { (error) in
                            promise.reject(error)
                        }
                case .image:
                    UIImage.downloadImage(url: uploadFile)
                        .done { (image) in
                            let localFile = LocalFile(image: image)
                            promise.fulfill(StoryImageSection(id: model.id, type: .image, file: localFile))
                        }
                        .catch { (error) in
                            promise.reject(error)
                        }
                }
            }
        }
    }
}
