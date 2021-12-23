//
//  InProgressTutorialViewController.swift
//  stori
//
//  Created by Alex on 21.12.2021.
//

import UIKit

protocol InProgressTutorialViewControllerDelegate: AnyObject {
    func didReceiveTouch()
}

class InProgressTutorialViewController: UIViewController {

    weak var inProgressTutorialDelegate: InProgressTutorialViewControllerDelegate?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            inProgressTutorialDelegate?.didReceiveTouch()
        }
        super.touchesBegan(touches, with: event)
    }

    // TODO: In Progress tutorial translate texts
}
