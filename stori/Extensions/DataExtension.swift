//
//  DataExtension.swift
//  stori
//
//  Created by Alex on 27.11.2020.
//

import Foundation

extension Data {
    func toDictionary() -> [String: Any]? {
        do {
            let json = try JSONSerialization.jsonObject(with: self,
                                                        options: .mutableContainers) as? [String: Any]
            return json
        } catch let JSONError {
            print(JSONError)
            return nil
        }
    }
}
