//
//  CSTableViewCellBuilder.swift
//  stori
//
//  Created by Alex on 01.02.2021.
//

import UIKit
import SwipeCellKit

class CSTableViewCellBuilder {
    static func buildCell(with item: StorySection, in tableView: UITableView) -> CSTableViewCell? {
        if let section = item as? StoryTextSection {
            let tCell = tableView.dequeueReusableCell(withIdentifier: CSTextItemTableViewCell.identifier)
            let cell = tCell as? CSTextItemTableViewCell
            cell?.setUp(section: section)
            return cell
        }
        if let section = item as? StoryImageSection {
            let tCell = tableView.dequeueReusableCell(withIdentifier: CSImageItemTableViewCell.identifier)
            let cell = tCell as? CSImageItemTableViewCell
            cell?.setUp(section: section)
            return cell
        }
        if let section = item as? StoryVideoSection {
            let tCell = tableView.dequeueReusableCell(withIdentifier: CSVideoItemTableViewCell.identifier)
            let cell = tCell as? CSVideoItemTableViewCell
            cell?.setUp(section: section)
            return cell
        }
        return nil
    }
}
