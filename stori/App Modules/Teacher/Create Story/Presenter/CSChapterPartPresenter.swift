//
//  CSChapterPartPresenter.swift
//  stori
//
//  Created by Alex on 01.03.2021.
//

import Foundation
import PromiseKit

class CSChapterPartPresenter {
    func getChapterParts(chapterId: Int) -> Promise<[StorySection]> {
        return Promise<[StorySection]> { promise in
            firstly {
                return Request(endpoint: Endpoints.storyParts(chapterId: chapterId),
                               method: .get)
                    .set(query: ["page_size": "100"])
                    .authorise()
                    .build()
            }
            .then { (request) -> Promise<ResponseObject<SectionModel>> in
                return APIClient.request(with: request)
            }
            .done { (response) in
                var promiseSections: [Promise<StorySection>] = []
                for item in response.results {
                    promiseSections.append(StorySectionBuilder.createItem(model: item))
                }
                when(fulfilled: promiseSections)
                    .done { (sections) in
                        promise.fulfill(sections)
                    }
                    .catch { (error) in
                        error.parse()
                        promise.reject(error)
                    }
            }
            .catch { (error) in
                error.parse()
                promise.reject(error)
            }
        }
    }
    
    func createChapterPart(chapterId: Int, part: StorySection) -> Promise<StorySection> {
        switch part.type {
        case .text:
            if let textPart = part as? StoryTextSection {
                return createTextPart(chapterId: chapterId, part: textPart)
            }
        case .image:
            if let imagePart = part as? StoryImageSection {
                return createImagePart(chapterId: chapterId, part: imagePart)
            }
        case .video:
            if let videoPart = part as? StoryVideoSection {
                return createVideoPart(chapterId: chapterId, part: videoPart)
            }
        }
        return Promise<StorySection> { promise in
            promise.reject(NetworkError.notFound)
        }
    }
    
    func updateChapterPart(part: StorySection) -> Promise<StorySection> {
        switch part.type {
        case .text:
            if let textPart = part as? StoryTextSection {
                return updateTextPart(part: textPart)
            }
        case .image:
            if let imagePart = part as? StoryImageSection {
                return updateImagePart(part: imagePart)
            }
        case .video:
            if let videoPart = part as? StoryVideoSection {
                return updateVideoPart(part: videoPart)
            }
        }
        return Promise<StorySection> { promise in
            promise.reject(NetworkError.notFound)
        }
    }
    
    func removeChapterPart(part: StorySection) {
        guard let partId = part.id else { return }
        firstly {
            return Request(endpoint: Endpoints.storyPart(partId: partId),
                           method: .delete)
                .authorise()
                .build()
        }
        .then { (request) -> Promise<DiscardableResponse> in
            return APIClient.request(with: request)
        }
        .done { (_) in
            debugPrint("DELETED Part with id: \(partId)")
        }
        .catch { (error) in
            debugPrint(error)
        }
    }
    
    func checkWords(words: [CSWord]) -> Promise<[CSWord]> {
        return Promise<[CSWord]> { promise in
            guard let chapterId = CreateStoryObject.shared?.chapter?.id else { return }
            let newWords = words.map { $0.word }
            firstly {
                return Request(endpoint: Endpoints.checkWords(chapterId: chapterId),
                               method: .post)
                    .authorise()
                    .set(body: [
                        "words": newWords
                    ])
                    .build()
            }
            .then { (request) -> Promise<[CheckWord]> in
                return APIClient.request(with: request)
            }
            .done { (result) in
                let newWords = words
                for index in 0..<result.count where newWords[index].word == result[index].word {
                    if let errorLevel = result[index].message {
                        newWords[index].isApproved = false
                        newWords[index].level = errorLevel
                    }
                }
                promise.fulfill(newWords)
            }
            .catch { (error) in
                promise.reject(error)
            }
        }
    }
    
    private func createTextPart(chapterId: Int, part: StoryTextSection) -> Promise<StorySection> {
        return Promise<StorySection> { promise in
            let newWords = part.words.map { $0.word }
            firstly {
                return Request(endpoint: Endpoints.storyParts(chapterId: chapterId),
                               method: .post)
                    .authorise()
                    .set(body: [
                        "type": 0,
                        "value": newWords
                    ])
                    .build()
            }
            .then { (request) -> Promise<SectionModel> in
                return APIClient.request(with: request)
            }
            .done { (result) in
                promise.fulfill(StoryTextSection(id: result.id,
                                                 text: result.text,
                                                 words: result.words))
            }
            .catch { (error) in
                promise.reject(error)
            }
        }
    }
    
    private func createImagePart(chapterId: Int, part: StoryImageSection) -> Promise<StorySection> {
        return Promise<StorySection> { promise in
            guard let imageId = part.file.id else { return }
            createMediaItem(chapterId: chapterId, body: [
                "type": 1,
                "value": imageId
            ])
            .done { (section) in
                promise.fulfill(section)
            }
            .catch { (error) in
                promise.reject(error)
            }
        }
    }
    
    private func createVideoPart(chapterId: Int, part: StoryVideoSection) -> Promise<StorySection> {
        return Promise<StorySection> { promise in
            guard let videoId = part.file.id else { return }
            guard let thumbnailId = part.thumbnail.id else { return }
            createMediaItem(chapterId: chapterId, body: [
                "type": 1,
                "value": videoId,
                "thumbnail": thumbnailId
            ])
            .done { (section) in
                promise.fulfill(section)
            }
            .catch { (error) in
                promise.reject(error)
            }
        }
    }
    
    private func createMediaItem(chapterId: Int, body: ParametersDict) -> Promise<StorySection> {
        return Promise<StorySection> { promise in
            firstly {
                return Request(endpoint: Endpoints.storyParts(chapterId: chapterId),
                               method: .post)
                    .authorise()
                    .set(body: body)
                    .build()
            }
            .then { (request) -> Promise<SectionModel> in
                return APIClient.request(with: request)
            }
            .then { (result) -> Promise<StorySection> in
                return StorySectionBuilder.createItem(model: result)
            }
            .done { (result) in
                promise.fulfill(result)
            }
            .catch { (error) in
                promise.reject(error)
            }
        }
    }
    
    private func updateTextPart(part: StoryTextSection) -> Promise<StorySection> {
        return Promise<StorySection> { promise in
            let newWords = part.words.map { $0.word }
            guard let partId = part.id else { return }
            firstly {
                return Request(endpoint: Endpoints.storyPart(partId: partId),
                               method: .patch)
                    .authorise()
                    .set(body: [
                        "value": newWords
                    ])
                    .build()
            }
            .then { (request) -> Promise<SectionModel> in
                return APIClient.request(with: request)
            }
            .done { (result) in
                promise.fulfill(StoryTextSection(id: result.id,
                                                 text: result.text,
                                                 words: result.words))
            }
            .catch { (error) in
                promise.reject(error)
            }
        }
    }
    
    private func updateImagePart(part: StoryImageSection) -> Promise<StorySection> {
        return Promise<StorySection> { promise in
            guard let imageId = part.file.id else { return }
            guard let partId = part.id else { return }
            updateMediaitem(partId: partId, body: [
                "value": imageId
            ])
            .done { (section) in
                promise.fulfill(section)
            }
            .catch { (error) in
                promise.reject(error)
            }
        }
    }
    
    private func updateVideoPart(part: StoryVideoSection) -> Promise<StorySection> {
        return Promise<StorySection> { promise in
            guard let videoId = part.file.id else { return }
            guard let thumbnailId = part.thumbnail.id else { return }
            guard let partId = part.id else { return }
            updateMediaitem(partId: partId, body: [
                "value": videoId,
                "thumbnail": thumbnailId
            ])
            .done { (section) in
                promise.fulfill(section)
            }
            .catch { (error) in
                promise.reject(error)
            }
        }
    }
    
    private func updateMediaitem(partId: Int, body: ParametersDict) -> Promise<StorySection> {
        return Promise<StorySection> { promise in
            firstly {
                return Request(endpoint: Endpoints.storyPart(partId: partId),
                               method: .patch)
                    .authorise()
                    .set(body: body)
                    .build()
            }
            .then { (request) -> Promise<SectionModel> in
                return APIClient.request(with: request)
            }
            .then { (result) -> Promise<StorySection> in
                return StorySectionBuilder.createItem(model: result)
            }
            .done { (result) in
                promise.fulfill(result)
            }
            .catch { (error) in
                promise.reject(error)
            }
        }
    }
}
