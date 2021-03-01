//
//  CSSuccessMessageViewController.swift
//  stori
//
//  Created by Alex on 08.02.2021.
//

import UIKit
import NVActivityIndicatorView
import PromiseKit

class CSSuccessMessageViewController: UIViewController {

    @IBOutlet weak var activityView: UIStackView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var completionView: UIStackView!
    @IBOutlet weak var completionIcon: UIImageView!
    @IBOutlet weak var completionTitle: UILabel!
    @IBOutlet weak var completionSubtitle: UILabel!
    @IBOutlet weak var completionDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoading()
        
        checkUploadedList { isSuccess in
            if isSuccess {
                guard let chapterId = CreateStoryObject.shared?.chapter?.id else { return }
                CSPresenter.chapter.saveChapter(chapterId: chapterId)
                    .done { _ in
                        self.showSuccess()
                    }
                    .catch { _ in
                        self.showFailure()
                    }
            } else {
                self.showFailure()
            }
        }
    }
    
    @objc func back(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func backToMain(sender: UIBarButtonItem) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: TeacherNetworkViewController.self) {
                self.navigationController?.popToViewController(controller, animated: true)
                CreateStoryObject.shared = nil
                break
            }
        }
    }
    
    private func showLoading() {
        title = "cs_message_loading_title".localized
        activityLabel.text = "cs_message_loading_subtitle".localized
        activityView.alpha = 1
        completionView.alpha = 0
        activityIndicator.startAnimating()
        self.navigationItem.hidesBackButton = true
    }
    
    private func showSuccess() {
        completionIcon.image = UIImage(named: "check-circle")
        completionTitle.text = "cs_message_success_title".localized
        completionSubtitle.text = "cs_message_success_subtitle".localized
        completionDescription.text = "cs_message_success_description".localized
        UIView.animate(withDuration: 0.7) { [self] in
            self.activityView.alpha = 0
            self.completionView.alpha = 1
            self.title = "cs_message_success_navbar".localized
            
            let doneButton = UIBarButtonItem(title: "common_done_title".localized,
                                             style: UIBarButtonItem.Style.done,
                                             target: self,
                                             action: #selector(self.backToMain(sender:)))
            self.navigationItem.rightBarButtonItem = doneButton
        }
    }
    
    private func showFailure() {
        completionIcon.image = UIImage(named: "error-circle")
        completionTitle.text = "cs_message_error_title".localized
        completionSubtitle.text = "cs_message_error_subtitle".localized
        completionDescription.text = "cs_message_error_description".localized
        UIView.animate(withDuration: 0.7) { [self] in
            self.activityView.alpha = 0
            self.completionView.alpha = 1
            self.title = "cs_message_error_navbar".localized
            
            let doneButton = UIBarButtonItem(title: "cs_message_error_button".localized,
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
        
        var textItems: [StorySection] = []
        if let parts = CreateStoryObject.shared?.chapterStoryParts {
            for item in parts where item.type == .text {
                textItems.append(item)
            }
        }
        
        if !textItems.allSatisfy({ $0.finishedUpload }) {
            completion(false)
            return
        }
        
        canGo = CreateStoryObject.shared?.chapterStoryParts?.allSatisfy({ $0.finishedUpload }) ?? false
        
        if canGo {
           completion(true)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.checkUploadedList(retries: retries + 1, completion: completion)
            }
        }
    }
}
