//
//  CSChapterModel.swift
//  stori
//
//  Created by Alex on 18.02.2021.
//

import Foundation

struct CSChapterModel: Decodable {
    var id: Int?
    var languageLevel: LanguageLevel? {
        willSet {
            if languageLevel?.id != newValue?.id, languageLevel != nil {
                cover = nil
            }
        }
    }
    var cover: CoverImage? {
        willSet {
//            guard let id = id else { return }
//            CSPresenter.chapter.updateChapter(chapterId: id,
//                                              coverId: newValue?.id)
//                .cauterize()
        }
    }
    var voiceOver: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case languageLevel = "level"
        case cover
        case voiceOver = "voice_over"
    }
}
