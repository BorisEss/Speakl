//
//  CSPresenter.swift
//  stori
//
//  Created by Alex on 26.01.2021.
//

import Foundation
import PromiseKit

struct CSPresenter {
    static let story = CSStoryService()
    static let topic = CSTopicService()
    static let category = CSCategoryService()
    static let subCategory = CSSubCategoryService()
    static let langauge = CSLanguageService()
    static let languageLevel = CSLanguageLevelService()
    static let chapter = CSChapterService()
    static let chapterPart = CSChapterPartService()
    static let vocabulary = CSVocabularyService()
    static let grammar = CSGrammarService()
}
