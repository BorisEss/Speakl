//
//  ItemProtocol.swift
//  stori
//
//  Created by Alex on 26.01.2021.
//

import Foundation

protocol ItemProtocol: Decodable {
    var id: Int { get set }
    var name: String { get set }
    var image: String? { get set }
}

extension ItemProtocol {
    var imageUrl: URL? {
        return URL(string: image ?? "")
    }
}
