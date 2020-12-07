//
//  Toast.swift
//  stori
//
//  Created by Alex on 04.12.2020.
//

import Foundation
import SwiftMessages

class Toast {
    static func success(_ message: String) {
        showMessage(theme: Theme.success, message: message)
    }
    
    static func error(_ message: String) {
        showMessage(theme: Theme.error, message: message)
    }
    
    private static func showMessage(theme: Theme,
                                    duration: SwiftMessages.Duration = .seconds(seconds: 2),
                                    message: String) {
        let messageView =  MessageView.viewFromNib(layout: .cardView)
        var config = SwiftMessages.defaultConfig
        
        config.duration = duration
        config.interactiveHide = true
        config.dimMode = .gray(interactive: true)
        config.presentationContext = .window(windowLevel: .normal)
        
        messageView.configureTheme(theme)
        messageView.configureContent(title: "", body: message)
        
        messageView.iconLabel?.isHidden = true
        messageView.titleLabel?.isHidden = true
        messageView.button?.isHidden = true
        messageView.bodyLabel?.font = UIFont.IBMPlexSans()
        
        SwiftMessages.show(config: config, view: messageView)
    }
}
