//
//  CSChapterPresenter.swift
//  stori
//
//  Created by Alex on 17.02.2021.
//

import Foundation
import PromiseKit

class CSChapterPresenter {
    func createChapter(storyId: Int, languageLevelId: Int) -> Promise<CSChapterModel> {
        return Promise<CSChapterModel> { promise in
            firstly {
                return Request(endpoint: Endpoints.chapters(storyId: storyId), method: .post)
                    .authorise()
                    .set(body: ["level_id": languageLevelId])
                    .build()
            }
            .then { (request) -> Promise<CSChapterModel> in
                return APIClient.request(with: request)
            }
            .done { (response) in
                promise.fulfill(response)
            }
            .catch { (error) in
                error.parse()
                promise.reject(error)
            }
        }
    }
    
    func updateChapter(chapterId: Int, languageLevelId: Int?) -> Promise<CSChapterModel> {
        return updateChapter(chapterId: chapterId, body: ["level_id": languageLevelId])
    }
    
    func updateChapter(chapterId: Int, coverId: Int?) -> Promise<CSChapterModel> {
        return updateChapter(chapterId: chapterId, body: ["cover_id": coverId])
    }
    
    func updateChapter(chapterId: Int, backgroundAudioId: Int?) -> Promise<CSChapterModel> {
        return updateChapter(chapterId: chapterId, body: ["background_music_id": backgroundAudioId])
    }
    
    func updateChapter(chapterId: Int, voiceOverId: String?) -> Promise<CSChapterModel> {
        return updateChapter(chapterId: chapterId, body: ["voice_over_id": voiceOverId])
    }
    
    private func updateChapter(chapterId: Int, body: ParametersDict) -> Promise<CSChapterModel> {
        return Promise<CSChapterModel> { promise in
            firstly {
                return Request(endpoint: Endpoints.updateCreatedStoryChapter(chapterId: chapterId),
                               method: .patch)
                    .authorise()
                    .set(body: body)
                    .build()
            }
            .then { (request) -> Promise<CSChapterModel> in
                return APIClient.request(with: request)
            }
            .done { (response) in
                promise.fulfill(response)
            }
            .catch { (error) in
                error.parse()
                promise.reject(error)
            }
        }
    }
    
    func saveChapter(chapterId: Int) -> Promise<CSChapterModel> {
        return updateChapter(chapterId: chapterId, body: ["status": 3])
    }
}

struct CheckWord: Decodable {
    var message: String?
    var word: String
}
