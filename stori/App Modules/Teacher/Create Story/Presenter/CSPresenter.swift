//
//  CSPresenter.swift
//  stori
//
//  Created by Alex on 26.01.2021.
//

import Foundation
import PromiseKit

struct CSPresenter {
    static let story = CSStoryPresenter()
    static let topic = CSTopicPresenter()
    static let category = CSCategoryPresenter()
    static let subCategory = CSSubCategoryPresenter()
    static let langauge = CSLanguagePresenter()
    static let languageLevel = CSLanguageLevelPresenter()
    static let cover = CSCoverPresenter()
    static let backgroundSound = CSBackgroundSoundPresenter()
    static let chapter = CSChapterPresenter()
    static let chapterPart = CSChapterPartPresenter()
    static let vocabulary = CSVocabularyPresenter()
    static let grammar = CSGrammarPresenter()
}
