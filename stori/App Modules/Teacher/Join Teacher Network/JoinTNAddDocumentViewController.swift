//
//  JoinTNAddDocumentViewController.swift
//  stori
//
//  Created by Alex on 05.01.2021.
//

import UIKit

class JoinTNAddDocumentViewController: UIViewController {
    
    private var previewImageSegue = "previewImage"

    var completion: ((_ files: [UploadedFile]) -> Void)?
    
    var files: [UploadedFile] = []
    var userType: JoinTNUserType?
    var documentType: JoinTNDocumentType?
    var selectedItem: UploadedFile?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLanguage()
        setUpTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        completion?(files)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVc = segue.destination as? ImagePreviewViewController,
           let selectedItem = selectedItem {
            nextVc.title = selectedItem.name
            nextVc.image = selectedItem.image
        }
    }

    func setUpLanguage() {
        // TODO: Finish Language update
        if let documentType = documentType,
           let userType = userType {
            switch documentType {
            case .personalId:
                title = "Personal ID"
            case .document:
                switch userType {
                case .student:
                    title = "Student ID"
                case .master:
                    title = "Master's Degree"
                case .teacher:
                    title = "Certified Teacher"
                }
            case .selfieWithId:
                title = "Selfie with ID"
            }
        }
    }
    
    func setUpTableView() {
        tableView.register(UploadFileTableViewCell.nib(),
                           forCellReuseIdentifier: UploadFileTableViewCell.identifier)
        tableView.register(FileTableViewCell.nib(),
                           forCellReuseIdentifier: FileTableViewCell.identifier)
        tableView.reloadData()
    }
}

extension JoinTNAddDocumentViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return files.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let radius = cell.contentView.layer.cornerRadius
//        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == files.count {
            if let tempCell = tableView.dequeueReusableCell(withIdentifier: UploadFileTableViewCell.identifier),
               let cell = tempCell as? UploadFileTableViewCell {
                cell.completion = { [weak self] file in
                    self?.files.append(file)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self?.tableView.reloadData()
                    }
                }
                return cell
            }
        } else {
            if let tempCell = tableView.dequeueReusableCell(withIdentifier: FileTableViewCell.identifier),
               let cell = tempCell as? FileTableViewCell {
                cell.setUp(file: files[indexPath.section])
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != files.count {
            selectedItem = files[indexPath.section]
            performSegue(withIdentifier: previewImageSegue, sender: nil)
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
}
