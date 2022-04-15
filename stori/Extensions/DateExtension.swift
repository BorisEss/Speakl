//
//  DateExtension.swift
//  stori
//
//  Created by Alex on 15.04.2022.
//

import Foundation

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
