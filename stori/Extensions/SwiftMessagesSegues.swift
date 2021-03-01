//
//  SwiftMessagesSegues.swift
//  stori
//
//  Created by Alex on 15.02.2021.
//

import Foundation
import SwiftMessages

class SwiftMessagesBottomTabSegue: SwiftMessagesSegue {
    override public init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        configure(layout: .bottomTab)
    }
}

class SwiftMessagesCenterSegue: SwiftMessagesSegue {
    override public init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        configure(layout: .centered)
    }
}

class SwiftMessagesTopTabSegue: SwiftMessagesSegue {
    override public  init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        configure(layout: .topTab)
    }
}
