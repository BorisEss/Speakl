//
//  SwiftMessagesTopTabSegue.swift
//  stori
//
//  Created by Alex on 01.12.2020.
//

import Foundation
import SwiftMessages

class SwiftMessagesTopTabSegue: SwiftMessagesSegue {
    override public  init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        configure(layout: .topTab)
    }
}
