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
            guard let id = id else { return }
            if cover?.id != newValue?.id, cover != nil {
                backgroundSound = nil
            }
            CSPresenter.chapter.updateChapter(chapterId: id,
                                              coverId: newValue?.id)
                .cauterize()
        }
    }
    var backgroundSound: BackgroundAudio? {
        willSet {
            guard let id = id else { return }
            CSPresenter.chapter.updateChapter(chapterId: id,
                                              backgroundAudioId: newValue?.id)
                .cauterize()
        }
    }
    var voiceOver: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case languageLevel = "level"
        case cover
        case backgroundSound = "background_music"
        case voiceOver = "voice_over"
    }
}
