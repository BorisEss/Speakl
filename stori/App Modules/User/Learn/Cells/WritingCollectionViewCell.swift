//
//  WritingCollectionViewCell.swift
//  stori
//
//  Created by Alex on 26.01.2022.
//

import UIKit

struct WritingWord {
    var word: String
    var isEmpty: Bool
    var wasEmpty: Bool
}

enum WritingCollectionViewCellState {
    case standart
    case textField
    case incorrect
    case correct
}

class WritingCollectionViewCell: UICollectionViewCell {
    
    var state: WritingCollectionViewCellState = .standart {
        didSet {
            switch state {
            case .standart:
                cellView.borderWidth = 0
                inputTextFieldView.isHidden = true
                wordLabel.isHidden = false
            case .textField:
                cellView.borderWidth = 0
                inputTextFieldView.isHidden = false
                wordLabel.isHidden = true
            case .incorrect:
                cellView.borderColor = UIColor(named: "Tag Red")
                cellView.borderWidth = 2
                inputTextFieldView.isHidden = false
                wordLabel.isHidden = true
            case .correct:
                cellView.borderColor = UIColor(named: "Tag Green")
                cellView.borderWidth = 2
                inputTextFieldView.isHidden = false
                wordLabel.isHidden = true
            }
        }
    }
    
    var completion: (() -> Void)?
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var inputTextFieldView: UIStackView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var cellView: UIView!
    
    func setUp(word: WritingWord) {
        wordLabel.text = word.word
        if word.isEmpty {
            state = .textField
            inputTextField.delegate = self
        } else {
            state = .standart
        }
    }
    
    func check() {
        guard let inputText = inputTextField.text,
              let labelText = wordLabel.text else { return }
        guard !inputText.isEmpty,
              !labelText.isEmpty else { return }
        let mText = inputText.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if mText == labelText.uppercased() {
            state = .correct
            inputTextField.isEnabled = false
            inputTextField.text = wordLabel.text
            completion?()
        } else {
            state = .incorrect
        }
    }
    
    @IBAction func fieldBeginAction(_ sender: Any) {
        cellView.borderColor = UIColor(named: "GradientBottom")
        cellView.borderWidth = 2
    }
    @IBAction func fieldEndAction(_ sender: Any) {
        if let inputText = inputTextField.text,
           inputText.isEmpty {
            cellView.borderColor = .clear
            cellView.borderWidth = 0
        } else {
            check()
        }
    }
}

extension WritingCollectionViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        check()
        return true
    }
}
