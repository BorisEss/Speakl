//
//  CSRecordVoiceListViewController.swift
//  stori
//
//  Created by Alex on 29.01.2021.
//

import UIKit
import MobileCoreServices

class CSRecordVoiceListViewController: UIViewController {
    
    var recording: LocalFile? {
        didSet {
            recordVoiceButton.isEnabled = recording == nil
            recordVoiceButton.backgroundColor = recording == nil ? .speaklAccentColor : .speaklGreyLight
            uploadFileButton.isEnabled = recording == nil
            uploadFileButton.backgroundColor = recording == nil ? .speaklAccentColor : .speaklGreyLight
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var recordVoiceButton: UIButton!
    @IBOutlet weak var uploadFileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpLanguage()
        setUpTableView()
        
        if let voiceOver = CreateStoryObject.shared?.chapter?.voiceOver {
            recording = LocalFile(voiceOverUrl: voiceOver)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVc = segue.destination as? CSRecordVoiceViewController {
            nextVc.completion = { url in
                self.recording = LocalFile(url: url.absoluteString,
                                           fileType: .audioM4a,
                                           name: "cs_recording_voice_over".localized)
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func uploadFileButtonPressed(_ sender: Any) {
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypeMP3), String(kUTTypeMPEG4Audio)],
                                                        in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        importMenu.allowsMultipleSelection = false
        self.present(importMenu, animated: true, completion: nil)
    }
    
    private func setUpLanguage() {
        title = "cs_recording_list_title".localized
        noDataLabel.text = "cs_recording_list_no_data_title".localized
    }
    
    private func setUpTableView() {
        tableView.register(FileTableViewCell.nib(),
                           forCellReuseIdentifier: FileTableViewCell.identifier)
    }
}

extension CSRecordVoiceListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        noDataLabel.isHidden = recording != nil
        return recording == nil ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tempCell = tableView.dequeueReusableCell(withIdentifier: FileTableViewCell.identifier),
           let cell = tempCell as? FileTableViewCell,
           let recording = recording {
            cell.setUp(file: recording)
            cell.removeButton.isHidden = true
            cell.shouldRemove = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.recording?.upload()
                self.recording?.finishedUpload = { fileId in
                    cell.removeButton.isHidden = false
                    guard let chapterId = CreateStoryObject.shared?.chapter?.id else { return }
                    CSPresenter.chapter.updateChapter(chapterId: chapterId,
                                                      voiceOverId: fileId)
                        .done({ (model) in
                            CreateStoryObject.shared?.chapter = model
                        })
                        .cauterize()
                }
            }
            cell.removeHadler = {
                guard let chapterId = CreateStoryObject.shared?.chapter?.id else { return }
                CSPresenter.chapter.updateChapter(chapterId: chapterId,
                                                  voiceOverId: nil)
                    .done({ (model) in
                        CreateStoryObject.shared?.chapter = model
                    })
                    .cauterize()
                self.recording = nil
            }
            return cell
        }
        return UITableViewCell()
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

// MARK: UIDocumentPickerDelegate
extension CSRecordVoiceListViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let audioUrl = urls.first {
            switch audioUrl.pathExtension {
            case "m4a":
                recording = LocalFile(url: audioUrl.absoluteString,
                                      fileType: .audioM4a,
                                      name: "cs_recording_voice_over".localized)
            case "mp3":
                recording = LocalFile(url: audioUrl.absoluteString,
                                      fileType: .audioMp3,
                                      name: "cs_recording_voice_over".localized)
            default:
                break
            }
        }
    }
}
