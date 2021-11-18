//
//  JoinTNSuccessMessageViewController.swift
//  stori
//
//  Created by Alex on 05.01.2021.
//

import UIKit
import NVActivityIndicatorView

class JoinTNSuccessMessageViewController: UIViewController {
    
    var isCheck: Bool = false
    
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
        
        if isCheck {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showSuccess()
            }
            return
        }
        
        guard let userType = userType else {
            navigationController?.popViewController(animated: true)
            return
        }

        checkUploadedList { isSuccess in
            if isSuccess {
                JoinTNService().join(personalId: self.personalIdList,
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    @objc func back(sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: false)
    }
    
    private func showLoading() {
        title = "common_uploading".localized
        activityView.alpha = 1
        completionView.alpha = 0
        activityIndicator.startAnimating()
        self.navigationItem.hidesBackButton = true
    }
    
    private func showSuccess() {
        completionIcon.image = UIImage(named: "check-circle")
        completionTitle.text = "join_tn_message_success_title".localized
        completionSubtitle.text = "join_tn_message_success_subtitle".localized
        completionDescription.text = "join_tn_message_success_description".localized
        UIView.animate(withDuration: 0.7) { [self] in
            self.activityView.alpha = 0
            self.completionView.alpha = 1
            self.title = "join_tn_message_success_navbartitle".localized
            
            let doneButton = UIBarButtonItem(title: "common_done_title".localized,
                                             style: UIBarButtonItem.Style.done,
                                             target: self,
                                             action: #selector(self.back(sender:)))
            self.navigationItem.rightBarButtonItem = doneButton
        }
    }
    
    private func showFailure() {
        completionIcon.image = UIImage(named: "error-circle")
        completionTitle.text = "join_tn_message_error_title".localized
        completionSubtitle.text = "join_tn_message_error_subtitle".localized
        completionDescription.text = "join_tn_message_error_description".localized
        UIView.animate(withDuration: 0.7) { [self] in
            self.activityView.alpha = 0
            self.completionView.alpha = 1
            self.title = "join_tn_message_error_navbartitle".localized
            
            let doneButton = UIBarButtonItem(title: "join_tn_message_error_button".localized,
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
