//
//  GrammarService.swift
//  stori
//
//  Created by Alex on 01.09.2022.
//

import Foundation
import PromiseKit

class GrammarService {
    func getCategories() -> Promise<[GrammarCategory]> {
        return Promise<[GrammarCategory]> { promise in
            if let url = Bundle.main.url(forResource: "grammar", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode([GrammarCategory].self, from: data)
                    promise.fulfill(jsonData)
                } catch {
                    print("error:\(error)")
                    promise.reject(error)
                }
            } else {
                promise.reject(NetworkError.unknownError)
            }
        }
    }

    func getSubcategories(for category: GrammarCategory) -> Promise<GrammarSubcategory> {
        return Promise<GrammarSubcategory> { promise in
            if let url = Bundle.main.url(forResource: category.url, withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(GrammarSubcategory.self, from: data)
                    promise.fulfill(jsonData)
                } catch {
                    print("error:\(error)")
                    promise.reject(error)
                }
            } else {
                promise.reject(NetworkError.unknownError)
            }
        }
    }
    
    func getSubcategoryDetails(for subcategoryId: String) -> Promise<GrammarSubcategoryDetails> {
        return Promise<GrammarSubcategoryDetails> { promise in
            if let url = Bundle.main.url(forResource: subcategoryId, withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(GrammarSubcategoryDetails.self, from: data)
                    promise.fulfill(jsonData)
                } catch {
                    print("error:\(error)")
                    promise.reject(error)
                }
            } else {
                promise.reject(NetworkError.unknownError)
            }
        }
    }
}
