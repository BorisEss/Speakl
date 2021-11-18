//
//  CreateStoryObject.swift
//  stori
//
//  Created by Alex on 09.02.2021.
//

import Foundation

class CreateStoryObject {
    
    public static var shared: CreateStoryObject?
    
    var id: Int
    var name: String
    var language: Language? {
        willSet {
            if language?.id != newValue?.id, language != nil {
                topic = nil
                chapter?.languageLevel = nil
            }
            CSPresenter.story.updateStory(id: id, languageId: newValue?.id)
                .cauterize()
        }
    }
    var topic: Topic? {
        willSet {
            if topic?.id != newValue?.id, topic != nil {
                category = nil
            }
            CSPresenter.story.updateStory(id: id, topicId: newValue?.id, language: language)
                .cauterize()
        }
    }
    var category: Category? {
        willSet {
            if category?.id != newValue?.id, category != nil {
                subCategory = nil
            }
            CSPresenter.story.updateStory(id: id, categoryId: newValue?.id, language: language)
                .cauterize()
        }
    }
    var subCategory: SubCategory? {
        willSet {
            if subCategory?.id != newValue?.id, subCategory != nil {
                chapter?.cover = nil
            }
            CSPresenter.story.updateStory(id: id, subCategoryId: newValue?.id, language: language)
                .cauterize()
        }
    }
    var chapter: CSChapterModel?
    var chapterStoryParts: [StorySection]?
    
    init(id: Int,
         name: String) {
        self.id = id
        self.name = name
    }
    
    init(model: CreateStoryModel) {
        id = model.id
        name = model.name
    }
    
}
