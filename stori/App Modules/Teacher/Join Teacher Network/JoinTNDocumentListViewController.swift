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
    var finishRegistration = "finishRegistration"
    
    var userType: JoinTNUserType?
    var uploadingDocumentType: JoinTNDocumentType?
    
    var personalIdList: [LocalFile] = []
    var documentList: [LocalFile] = []
    var selfieWithIdList: [LocalFile] = []
    
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
        if segue.identifier == finishRegistration,
           let nextVc = segue.destination as? JoinTNSuccessMessageViewController {
            nextVc.userType = userType
            nextVc.personalIdList = personalIdList
            nextVc.documentList = documentList
            nextVc.selfieWithIdList = selfieWithIdList
        }
    }
    
    @IBAction func uploadDocumentPressed(_ sender: UIButton) {
        uploadingDocumentType = JoinTNDocumentType(rawValue: sender.tag)
        if uploadingDocumentType != nil {
            performSegue(withIdentifier: uploadDocumentSegue, sender: nil)
        }
    }
    
    func setUpLanguage() {
        personalIdTitleLabel.text = "join_tn_document_personal_id".localized
        personalIdSubtitleLabel.text = "join_tn_document_personal_id_desc".localized
        if let userType = userType {
            switch userType {
            case .student:
                title = "join_tn_usertype_student".localized
                documentTitleLabel.text = "join_tn_document_student_id".localized
                documentSubtitleLabel.text = "join_tn_document_student_id_desc".localized
            case .master:
                title = "join_tn_usertype_master".localized
                documentTitleLabel.text = "join_tn_document_master_degree".localized
                documentSubtitleLabel.text = "join_tn_document_master_degree_desc".localized
            case .teacher:
                title = "join_tn_usertype_teacher".localized
                documentTitleLabel.text = "join_tn_document_teacher_certificate".localized
                documentSubtitleLabel.text = "join_tn_document_teacher_certificate_desc".localized
            }
        }
        selfieWithIdTitleLabel.text = "join_tn_document_selfie".localized
        selfieWithIdSubtitleLabel.text = "join_tn_document_selfie_desc".localized
        submitButton.setTitle("join_tn_document_submit_button".localized,
                              for: .normal)
        submitButton.setTitle("join_tn_document_submit_button".localized,
                              for: .disabled)
    }
    
    func submissionCheck() {
        personalIdCheckImage.backgroundColor = personalIdList.isEmpty ? .accentColor : .clear
        documentCheckImage.backgroundColor = documentList.isEmpty ? .accentColor : .clear
        selfieWithIdCheckImage.backgroundColor = selfieWithIdList.isEmpty ? .accentColor : .clear
        submitButton.isEnabled = !(personalIdList.isEmpty || documentList.isEmpty || selfieWithIdList.isEmpty)
    }
}
