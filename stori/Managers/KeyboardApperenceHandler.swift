//
//  KeyboardApperenceHandler.swift
//  stori
//
//  Created by Alex on 25.11.2020.
//

import Foundation
import UIKit

protocol KeyboardApperenceHandlerDelegate: AnyObject {
    func keyboardWillAppear(keyboardHeight: CGFloat)
    func keyboardWillDisapear()
}

class KeyboardApperenceHandler {
    public weak var delegate: KeyboardApperenceHandlerDelegate?
    
    func subscribe(delegate: KeyboardApperenceHandlerDelegate?) {
        self.delegate = delegate
        
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(keyboardWillAppear(_:)),
                           name: UIResponder.keyboardWillShowNotification,
                           object: nil)
        center.addObserver(self,
                           selector: #selector(keyboardWillDisapear(_:)),
                           name: UIResponder.keyboardWillHideNotification,
                           object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillAppear(_ notification: Notification?) {
        if  let value = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey],
            let rect = (value as? NSValue)?.cgRectValue {
            delegate?.keyboardWillAppear(keyboardHeight: rect.height)
        }
    }
    
    @objc private func keyboardWillDisapear(_ notification: Notification?) {
        delegate?.keyboardWillDisapear()
    }
}
