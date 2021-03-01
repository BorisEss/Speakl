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
    
    @IBOutlet weak var personalIdItem: ItemViewWithSubtitleAndCheckmark!
    @IBOutlet weak var documentItem: ItemViewWithSubtitleAndCheckmark!
    @IBOutlet weak var selfieWithIdItem: ItemViewWithSubtitleAndCheckmark!
    
    @IBOutlet weak var submitButton: RegularButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLanguage()
        setUpActions()
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
    
    func setUpLanguage() {
        personalIdItem.setUp(title: "join_tn_document_personal_id".localized,
                             subtitle: "join_tn_document_personal_id_desc".localized)
        if let userType = userType {
            switch userType {
            case .student:
                title = "join_tn_usertype_student".localized
                documentItem.setUp(title: "join_tn_document_student_id".localized,
                                   subtitle: "join_tn_document_student_id_desc".localized)
            case .master:
                title = "join_tn_usertype_master".localized
                documentItem.setUp(title: "join_tn_document_master_degree".localized,
                                   subtitle: "join_tn_document_master_degree_desc".localized)
            case .teacher:
                title = "join_tn_usertype_teacher".localized
                documentItem.setUp(title: "join_tn_document_teacher_certificate".localized,
                                   subtitle: "join_tn_document_teacher_certificate_desc".localized)
            }
        }
        selfieWithIdItem.setUp(title: "join_tn_document_selfie".localized,
                               subtitle: "join_tn_document_selfie_desc".localized)
        submitButton.setTitle("join_tn_document_submit_button".localized,
                              for: .normal)
        submitButton.setTitle("join_tn_document_submit_button".localized,
                              for: .disabled)
    }
    
    func setUpActions() {
        personalIdItem.onClick = {
            self.uploadingDocumentType = .personalId
            if self.uploadingDocumentType != nil {
                self.performSegue(withIdentifier: self.uploadDocumentSegue, sender: nil)
            }
        }
        documentItem.onClick = {
            self.uploadingDocumentType = .document
            if self.uploadingDocumentType != nil {
                self.performSegue(withIdentifier: self.uploadDocumentSegue, sender: nil)
            }
        }
        selfieWithIdItem.onClick = {
            self.uploadingDocumentType = .selfieWithId
            if self.uploadingDocumentType != nil {
                self.performSegue(withIdentifier: self.uploadDocumentSegue, sender: nil)
            }
        }
    }
    
    func submissionCheck() {
        personalIdItem.isChecked = !personalIdList.isEmpty
        documentItem.isChecked = !documentList.isEmpty
        selfieWithIdItem.isChecked = !selfieWithIdList.isEmpty
        submitButton.isEnabled = !(personalIdList.isEmpty || documentList.isEmpty || selfieWithIdList.isEmpty)
    }
}
