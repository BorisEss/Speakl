//
//  JoinTNDocumentListViewController.swift
//  stori
//
//  Created by Alex on 05.01.2021.
//

import UIKit

enum JoinTNDocumentType: Int {
    case personalId = 0
    case document = 1
    case selfieWithId = 2
}

class JoinTNDocumentListViewController: UIViewController {

    var uploadDocumentSegue = "uploadDocument"
    
    var userType: JoinTNUserType?
    var uploadingDocumentType: JoinTNDocumentType?
    
    var personalIdList: [UploadedFile] = []
    var documentList: [UploadedFile] = []
    var selfieWithIdList: [UploadedFile] = []
    
    @IBOutlet weak var personalIdCheckImage: UIImageView!
    @IBOutlet weak var personalIdTitleLabel: UILabel!
    @IBOutlet weak var personalIdSubtitleLabel: UILabel!
    
    @IBOutlet weak var documentCheckImage: UIImageView!
    @IBOutlet weak var documentTitleLabel: UILabel!
    @IBOutlet weak var documentSubtitleLabel: UILabel!
    
    @IBOutlet weak var selfieWithIdCheckImage: UIImageView!
    @IBOutlet weak var selfieWithIdTitleLabel: UILabel!
    @IBOutlet weak var selfieWithIdSubtitleLabel: UILabel!
    
    @IBOutlet weak var submitButton: RegularButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLanguage()
        submissionCheck()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == uploadDocumentSegue,
           let nextVc = segue.destination as? JoinTNAddDocumentViewController,
           let documentType = uploadingDocumentType {
            nextVc.userType = userType
            nextVc.documentType = uploadingDocumentType
            switch documentType {
            case .personalId:
                nextVc.files = personalIdList
            case .document:
                nextVc.files = documentList
            case .selfieWithId:
                nextVc.files = selfieWithIdList
            }
            nextVc.completion = { ids in
                switch documentType {
                case .personalId:
                    self.personalIdList = ids
                case .document:
                    self.documentList = ids
                case .selfieWithId:
                    self.selfieWithIdList = ids
                }
                self.uploadingDocumentType = nil
                self.submissionCheck()
            }
        }
    }
    
    @IBAction func uploadDocumentPressed(_ sender: UIButton) {
        uploadingDocumentType = JoinTNDocumentType(rawValue: sender.tag)
        if uploadingDocumentType != nil {
            performSegue(withIdentifier: uploadDocumentSegue, sender: nil)
        }
    }
    
    func setUpLanguage() {
        // TODO: Finish language
        personalIdTitleLabel.text = "Personal ID"
        personalIdSubtitleLabel.text = "Upload Government ID (Front & Back)"
        if let userType = userType {
            switch userType {
            case .student:
                title = "Student"
                documentTitleLabel.text = "Student ID"
                documentSubtitleLabel.text = "Upload your student ID (Front & Back)"
            case .master:
                title = "Master's Degree"
                documentTitleLabel.text = "Master's Degree"
                documentSubtitleLabel.text = "Upload your Masters Degree"
            case .teacher:
                title = "Certified Teacher"
                documentTitleLabel.text = "Certified Teacher"
                documentSubtitleLabel.text = "Upload your Teacher Certificate"
            }
        }
        selfieWithIdTitleLabel.text = "Selfie with ID"
        selfieWithIdSubtitleLabel.text = "Upload a selfie with your ID next to you"
        submitButton.setTitle("Submit for Review", for: .normal)
        submitButton.setTitle("Submit for Review", for: .disabled)
    }
    
    func submissionCheck() {
        personalIdCheckImage.backgroundColor = personalIdList.isEmpty ? .accentColor : .clear
        documentCheckImage.backgroundColor = documentList.isEmpty ? .accentColor : .clear
        selfieWithIdCheckImage.backgroundColor = selfieWithIdList.isEmpty ? .accentColor : .clear
        submitButton.isEnabled = !(personalIdList.isEmpty || documentList.isEmpty || selfieWithIdList.isEmpty)
    }
}
