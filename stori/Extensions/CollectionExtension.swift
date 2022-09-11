//
//  CollectionExtension.swift
//  stori
//
//  Created by Alex on 08.09.2022.
//

import Foundation

extension Collection {
    subscript(optional index: Index) -> Iterator.Element? {
        return self.indices.contains(index) ? self[index] : nil
    }
}
