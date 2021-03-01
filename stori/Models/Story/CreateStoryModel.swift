//
//  CreateStoryModel.swift
//  stori
//
//  Created by Alex on 09.02.2021.
//

import Foundation

struct CreateStoryModel: Decodable {
    var id: Int
    var name: String
    var language: Language?
    var topic: Topic?
    var category: Category?
    var subCategory: SubCategory?
}
