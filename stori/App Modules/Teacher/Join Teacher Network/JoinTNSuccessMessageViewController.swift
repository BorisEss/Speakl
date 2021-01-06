//
//  JoinTNSuccessMessageViewController.swift
//  stori
//
//  Created by Alex on 05.01.2021.
//

import UIKit
import NVActivityIndicatorView

class JoinTNSuccessMessageViewController: UIViewController {

    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var activityView: UIStackView!
    @IBOutlet weak var completionView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Uploading"
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.7) { [self] in
                self.activityView.alpha = 0
                self.completionView.alpha = 1
                self.title = "Thank You!"
                
                self.navigationItem.hidesBackButton = true
                let doneButton = UIBarButtonItem(title: "Done",
                                                 style: UIBarButtonItem.Style.done,
                                                 target: self,
                                                 action: #selector(self.back(sender:)))
                self.navigationItem.rightBarButtonItem = doneButton
            }
        }
    }
    
    @objc func back(sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: false)
    }
}
