//
//  ShareFeedbackViewController.swift
//  stori
//
//  Created by Alex on 27.04.2021.
//

import UIKit
import UITextView_Placeholder

class ShareFeedbackViewController: UIViewController {
    
    @IBOutlet var ratingButtons: [RatingButton]!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var submitButton: RegularButton!
    @IBOutlet weak var progressActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLanguage()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? WebBrowserViewController {
            controller.title = "common_terms_and_conditions".localized
            controller.url = Endpoints.termsAndConditions
            return
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        if let checkedRating = ratingButtons.first(where: { $0.isChecked }),
           let message = messageTextView.text {
            for item in  ratingButtons { item.isEnabled = false }
            messageTextView.isUserInteractionEnabled = false
            submitButton.isHidden = true
            progressActivityIndicator.startAnimating()
            ShareFeedbackPresenter.sendFeedback(rating: checkedRating.tag, message: message)
                .ensure {
                    for item in self.ratingButtons { item.isEnabled = true }
                    self.messageTextView.isUserInteractionEnabled = true
                    self.submitButton.isHidden = false
                    self.progressActivityIndicator.stopAnimating()
                }
                .done { _ in
                    for item in self.ratingButtons { item.isChecked = false }
                    self.messageTextView.text = ""
                    Toast.success("feedback_success_message".localized)
                }
                .catch { error in
                    error.parse()
                }
        }
    }
    
    @IBAction func ratingButtonSelected(_ sender: RatingButton) {
        if let checkedButton = ratingButtons.first(where: { $0.isChecked }) {
            checkedButton.isChecked = false
        }
        Vibration().light()
        sender.isChecked = true
        checkFields()
    }
    
    private func setUpLanguage() {
        title = "feedback_title".localized
        messageTextView.placeholder = "feedback_message_placeholder".localized
    }
    
    private func checkFields() {
        if !ratingButtons.contains(where: { $0.isChecked }) {
            submitButton.isEnabled = false
            return
        }
        if let message =  messageTextView.text,
           message.isEmpty {
            submitButton.isEnabled = false
            return
        }
        submitButton.isEnabled = true
    }
}

extension ShareFeedbackViewController: UITextViewDelegate {
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 255
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkFields()
    }
}
