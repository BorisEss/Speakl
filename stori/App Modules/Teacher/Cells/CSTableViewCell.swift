//
//  CSTableViewCell.swift
//  stori
//
//  Created by Alex on 02.02.2021.
//

import UIKit
import SwipeCellKit

class CSTableViewCell: SwipeTableViewCell, CustomTableViewCell {
    var editActionCallback: (() -> Void)?
}
