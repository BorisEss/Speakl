//
//  StoryLearningButton.swift
//  stori
//
//  Created by Alex on 01.09.2021.
//

import UIKit

class StoryLearningButton: UIButton {
    func empty() {
        borderWidth = 2
        borderColor = .white
        backgroundColor = .clear
    }
    func inProgress() {
        borderWidth = 0
        backgroundColor = .inProgressYellow
    }
    
    func finished() {
        borderWidth = 0
        backgroundColor = .completedPurple
    }
}
