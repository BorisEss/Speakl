//
//  StoryImageSection.swift
//  stori
//
//  Created by Alex on 01.03.2021.
//

import Foundation
import PromiseKit

class StoryImageSection: StorySection {
    var file: LocalFile
    
    init(chapterId: Int,
         type: StorySectionType,
         file: LocalFile) {
        self.file = file
        super.init(type: type)
        createSection(chapterId: chapterId)
    }
    
    init(id: Int,
         type: StorySectionType,
         file: LocalFile) {
        self.file = file
        super.init(id: id,
                   type: type)
    }
    
    func updateImage(newImage: LocalFile) {
        if newImage.id == nil {
            finishedUpload = false
            file = newImage
            file.upload()
            file.finishedUpload = { _ in
                self.finishedUpload = true
                self.didFinishUpload?()
                CSPresenter.chapterPart.updateChapterPart(part: self)
                    .done { (section) in
                        guard let imageSection = section as? StoryImageSection else { return }
                        self.file = imageSection.file
                    }
                    .cauterize()
            }
        }
    }
    
    func createSection(chapterId: Int) {
        if file.id == nil {
            finishedUpload = false
            file.upload()
            file.finishedUpload = { _ in
                self.finishedUpload = true
                self.didFinishUpload?()
                CSPresenter.chapterPart.createChapterPart(chapterId: chapterId, part: self)
                    .done { (section) in
                        guard let imageSection = section as? StoryImageSection else { return }
                        self.id = imageSection.id
                        self.file = imageSection.file
                    }
                    .cauterize()
            }
        }
    }
}
