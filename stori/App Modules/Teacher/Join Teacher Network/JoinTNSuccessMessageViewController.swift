//
//  JoinTNSuccessMessageViewController.swift
//  stori
//
//  Created by Alex on 05.01.2021.
//

import UIKit
import NVActivityIndicatorView

class JoinTNSuccessMessageViewController: UIViewController {
    
    var userType: JoinTNUserType?
    var personalIdList: [LocalFile] = []
    var documentList: [LocalFile] = []
    var selfieWithIdList: [LocalFile] = []

    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var activityView: UIStackView!
    @IBOutlet weak var completionView: UIStackView!
    @IBOutlet weak var completionIcon: UIImageView!
    @IBOutlet weak var completionTitle: UILabel!
    @IBOutlet weak var completionSubtitle: UILabel!
    @IBOutlet weak var completionDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showLoading()
        
        guard let userType = userType else {
            navigationController?.popViewController(animated: true)
            return
        }

        checkUploadedList { isSuccess in
            if isSuccess {
                JoinTNPresenter().join(personalId: self.personalIdList,
                                       documentId: self.documentList,
                                       selfie: self.selfieWithIdList,
                                       type: userType) { (isSuccess) in
                    if isSuccess {
                        self.showSuccess()
                    } else {
                        self.showFailure()
                    }
                }
            } else {
                self.showFailure()
            }
        }
    }
    
    @objc func back(sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: false)
    }
    
    // TODO: Add translations
    private func showLoading() {
        title = "Uploading"
        activityView.alpha = 1
        completionView.alpha = 0
        activityIndicator.startAnimating()
        self.navigationItem.hidesBackButton = true
    }
    
    private func showSuccess() {
        completionIcon.image = UIImage(named: "check-circle")
        completionTitle.text = "Congratulations!"
        completionSubtitle.text = "We received your documents"
        completionDescription.text = "Thank you so much for submission! Your account is in review and you should receive an email shortly."
        UIView.animate(withDuration: 0.7) { [self] in
            self.activityView.alpha = 0
            self.completionView.alpha = 1
            self.title = "Thank You!"
            
            let doneButton = UIBarButtonItem(title: "Done",
                                             style: UIBarButtonItem.Style.done,
                                             target: self,
                                             action: #selector(self.back(sender:)))
            self.navigationItem.rightBarButtonItem = doneButton
        }
    }
    
    private func showFailure() {
        completionIcon.image = UIImage(named: "error-circle")
        completionTitle.text = "Whoops..."
        completionSubtitle.text = "Something went wrong"
        completionDescription.text = "Please try again to upload your documents."
        UIView.animate(withDuration: 0.7) { [self] in
            self.activityView.alpha = 0
            self.completionView.alpha = 1
            self.title = "Error!"
            
            let doneButton = UIBarButtonItem(title: "Try Again!",
                                             style: UIBarButtonItem.Style.done,
                                             target: self,
                                             action: #selector(self.back(sender:)))
            self.navigationItem.rightBarButtonItem = doneButton
        }
    }
    
    private func checkUploadedList(retries: Int = 0,
                                   completion: @escaping (Bool) -> Void) {
        
        if retries == 120 { completion(false) }
        
        var canGo = true
        
        for item in personalIdList where item.id == nil {
            canGo = false
        }
        for item in documentList where item.id == nil {
            canGo = false
        }
        for item in selfieWithIdList where item.id == nil {
            canGo = false
        }
        
        if canGo {
            completion(true)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.checkUploadedList(retries: retries + 1, completion: completion)
            }
        }
    }
}
