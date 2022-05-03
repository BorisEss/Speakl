//
//  UITableViewExtension.swift
//  stori
//
//  Created by Alex on 19.03.2022.
//

import UIKit

extension UITableView {
    func scrollToBottom(isAnimated: Bool = true) {
        DispatchQueue.main.async { [self] in
            let indexPath = IndexPath(
                row: numberOfRows(inSection: numberOfSections - 1) - 1,
                section: numberOfSections - 1)
            if hasRowAtIndexPath(indexPath: indexPath) {
                scrollToRow(at: indexPath, at: .bottom, animated: isAnimated)
            }
        }
    }

    func scrollToTop(isAnimated: Bool = true) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: isAnimated)
           }
        }
    }

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < numberOfSections && indexPath.row < numberOfRows(inSection: indexPath.section)
    }
}
