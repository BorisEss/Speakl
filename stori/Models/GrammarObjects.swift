//
//  GrammarObjects.swift
//  stori
//
//  Created by Alex on 07.09.2022.
//

import Foundation
import SpreadsheetView

struct GrammarCategory: Decodable {
    var id: Int
    var name: String
    var icon: String
    var url: String
    var hasSubcategories: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case icon
        case url
        case hasSubcategories = "has_subcategories"
    }    
}

struct GrammarSubcategoryItem: Decodable {
    var id: Int
    var name: String
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case url
    }
}

struct GrammarSubcategory: Decodable {
    var id: Int
    var name: String
    var description: String
    var items: [GrammarSubcategoryItem]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description = "explanation"
        case items = "categories"
    }
}

enum TableType: Int, Decodable {
    case twoColumns = 0
    case twoColumnsWithTitle = 1
    case threeColumns = 2
    case fourColumns = 3
    case twoColumnsGrouped = 4
}

struct GrammarSubcategoryDetails: Decodable {
    var description: String
    var tableData: TableData
    var stories: [String]
    
    enum CodingKeys: String, CodingKey {
        case description = "explanation"
        case tableData = "table"
        case stories
    }
}

struct IndexObject: Decodable {
    var row: Int
    var column: Int
    
    var asIndexPath: IndexPath {
        return IndexPath(row: row, column: column)
    }
}

struct MergedRangeItem: Decodable {
    var fromIndex: IndexObject
    var toIndex: IndexObject
    
    var asCellRange: CellRange {
        return CellRange(from: fromIndex.asIndexPath, to: toIndex.asIndexPath)
    }
    
    enum CodingKeys: String, CodingKey {
        case fromIndex = "from"
        case toIndex = "to"
    }
}

struct TableData: Decodable {
    var tableType: TableType
    var title: String?
    var subtitle1: [String]?
    var subtitle2: [String]?
    var data: [[String]]?
    var groupedData: [String: [String]]?
    var mergedItems: [MergedRangeItem]?
    
    enum CodingKeys: String, CodingKey {
        case tableType = "table_type"
        case title
        case subtitle1 = "subtitle_1"
        case subtitle2 = "subtitle_2"
        case data
        case groupedData = "grouped_data"
        case mergedItems = "merged_items"
    }
}
