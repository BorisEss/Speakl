//
//  StoryVideoSection.swift
//  stori
//
//  Created by Alex on 01.03.2021.
//

import Foundation
import PromiseKit

class StoryVideoSection: StorySection {
    var file: LocalFile
    var thumbnail: LocalFile
    
    init(chapterId: Int,
         type: StorySectionType,
         file: LocalFile) {
        self.file = file
        self.thumbnail = LocalFile(image: file.image ?? UIImage())
        super.init(type: type)
        createSection(chapterId: chapterId)
    }
    
    init(id: Int,
         type: StorySectionType,
         file: LocalFile) {
        self.file = file
        self.thumbnail = LocalFile(image: file.image ?? UIImage())
        super.init(id: id,
                   type: type)
    }
    
    func updateVideo(newVideo: LocalFile) {
        if newVideo.id == nil {
            finishedUpload = false
            file = newVideo
            file.upload()
            file.finishedUpload = { _ in
                if let thumbnail = self.file.image {
                    self.thumbnail = LocalFile(image: thumbnail)
                    self.thumbnail.upload()
                    self.thumbnail.finishedUpload = { _ in
                        self.finishedUpload = true
                        self.didFinishUpload?()
                        CSPresenter.chapterPart.updateChapterPart(part: self)
                            .done { (section) in
                                guard let videoSection = section as? StoryVideoSection else { return }
                                self.file = videoSection.file
                            }
                            .cauterize()
                    }
                } else {
                    self.finishedUpload = true
                    self.didFinishUpload?()
                }
            }
        }
    }
    
    func createSection(chapterId: Int) {
        if file.id == nil {
            finishedUpload = false
            file.upload()
            file.finishedUpload = { _ in
                if let thumbnail = self.file.image {
                    self.thumbnail = LocalFile(image: thumbnail)
                    self.thumbnail.upload()
                    self.thumbnail.finishedUpload = { _ in
                        self.finishedUpload = true
                        self.didFinishUpload?()
                        CSPresenter.chapterPart.updateChapterPart(part: self)
                            .done { (section) in
                                guard let videoSection = section as? StoryVideoSection else { return }
                                self.file = videoSection.file
                            }
                            .cauterize()
                    }
                } else {
                    self.finishedUpload = true
                    self.didFinishUpload?()
                }
            }
        }
    }
}
