//
//  LocalizationExtension.swift
//  stori
//
//  Created by Alex on 09.04.2021.
//

import UIKit

extension UILabel {
    @IBInspectable var localizedText: String? {
        get {
            return attributedText?.string ?? (text ?? "")
        }
        set {
            guard let newText = newValue?.localized else { return }
            if attributedText != nil {
                let string = NSMutableAttributedString(attributedString: attributedText!)
                string.mutableString.setString(newText)
                attributedText = string
            } else {
                text = newText
            }
        }
    }
}

extension UIBarItem {
    @IBInspectable var localizedText: String? {
        get {
            return title ?? ""
        }
        set {
            guard let newText = newValue?.localized else { return }
            title = newText
        }
    }
}

extension UIButton {
    @IBInspectable var localizedTitle: String? {
        get {
            return currentAttributedTitle?.string ?? (currentTitle ?? "")
        }
        set {
            guard let newText = newValue?.localized else { return }
            setTitle(newText, for: state)
        }
    }
}

extension UITextField {
    @IBInspectable var localizedPlaceholder: String? {
        get {
            return attributedPlaceholder?.string ?? (placeholder ?? "")
        }
        set {
            guard let newText = newValue?.localized else { return }
            if attributedPlaceholder != nil {
                let string = NSMutableAttributedString(attributedString: attributedPlaceholder!)
                string.mutableString.setString(newText)
                attributedPlaceholder = string
            } else {
                placeholder = newText
            }
        }
    }
}

extension UIBarButtonItem {
    @IBInspectable var localizedTitle: String? {
        get {
            return title
        }
        set {
            guard let newText = newValue?.localized else { return }
            title = newText
        }
    }
}
