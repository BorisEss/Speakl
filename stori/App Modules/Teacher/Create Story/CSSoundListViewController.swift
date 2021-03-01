//
//  CSSoundListViewController.swift
//  stori
//
//  Created by Alex on 27.01.2021.
//

import UIKit
import MobileCoreServices
import MarqueeLabel
import PromiseKit
import NVActivityIndicatorView

class CSSoundListViewController: UIViewController, UIGestureRecognizerDelegate {

    private var shouldShowNavbar: Bool = true
    
    var subCategory: SubCategory? = CreateStoryObject.shared?.subCategory
    var coverImage: CoverImage? = CreateStoryObject.shared?.chapter?.cover

    private var audioList: [BackgroundAudio] = []
    private var currentPlayingAudioIndex: Int? {
        didSet {
            guard let currentPlayingAudio = currentPlayingAudioIndex else {
                playPauseButton.setImage(UIImage(named: "play"), for: .normal)
                previousSkipButton.isEnabled = false
                playPauseButton.isEnabled = false
                nextSkipButton.isEnabled = false
                return
            }
            if currentPlayingAudio == 0 {
                DispatchQueue.main.async {
                    self.previousSkipButton.isEnabled = false
                    self.playPauseButton.isEnabled = true
                    self.nextSkipButton.isEnabled = self.audioList.count > 1
                }
            } else if currentPlayingAudio == audioList.count - 1 {
                DispatchQueue.main.async {
                    self.previousSkipButton.isEnabled = self.audioList.count != 1
                    self.playPauseButton.isEnabled = true
                    self.nextSkipButton.isEnabled = false
                }
                
            } else {
                DispatchQueue.main.async {
                    self.previousSkipButton.isEnabled = true
                    self.playPauseButton.isEnabled = true
                    self.nextSkipButton.isEnabled = true
                }
            }
        }
    }
    var currentPlayingAudio: BackgroundAudio?
    
    private var page: Int = 1
    private var canContinueToNextPage: Bool = true
    
    @IBOutlet weak var navBarTitleLabel: UILabel!
    
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var audioNameLabel: MarqueeLabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var previousSkipButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var nextSkipButton: UIButton!
    @IBOutlet weak var audioProgressView: UIProgressView!
    @IBOutlet weak var audioCoverImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var progressActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var uploadActivityIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpLanguage()
        setUpTableView()
        loadPreviewImage()
        audioList = []
        loadData(page: page)
        currentPlayingAudioIndex = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadPlayerCallbacks()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if shouldShowNavbar {
            navigationController?.setNavigationBarHidden(false, animated: true)
            AudioPlayer.shared.stop()
            guard let selectedItem = tableView.indexPathForSelectedRow else { return }
            CreateStoryObject.shared?.chapter?.backgroundSound = audioList[selectedItem.section]
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CSSoundListSearchViewController,
           let nextVc = segue.destination as? CSSoundListSearchViewController {
            shouldShowNavbar = false
            nextVc.coverImage = coverImage
            nextVc.currentPlayingAudio = currentPlayingAudio
            nextVc.completion = { file in
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.navigationController?.popViewController(animated: true)
                CreateStoryObject.shared?.chapter?.backgroundSound = file
            }
            nextVc.updateSongOnPreviousScreen = { file in
                self.audioNameLabel.text = file.name
            }
        } else if let nextVc = segue.destination as? CSCustomItemPopUpViewController {
            nextVc.descriptionText = "cs_background_music_custom_popup".localized
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypeMP3), String(kUTTypeMPEG4Audio)],
                                                        in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    @IBAction func skipPreviousPressed(_ sender: Any) {
        guard let section = currentPlayingAudioIndex else { return }
        tableView.deselectRow(at: IndexPath(row: 0, section: section), animated: true)
        tableView.selectRow(at: IndexPath(row: 0, section: section - 1),
                            animated: true, scrollPosition: .middle)
        self.currentPlayingAudioIndex = section - 1
        playAudio(item: audioList[section - 1])
    }
    @IBAction func playPausePressed(_ sender: Any) {
        AudioPlayer.shared.togglePlayPause()
    }
    @IBAction func skipNextPressed(_ sender: Any) {
        guard let section = currentPlayingAudioIndex else { return }
        tableView.deselectRow(at: IndexPath(row: 0, section: section), animated: true)
        tableView.selectRow(at: IndexPath(row: 0, section: section + 1),
                            animated: true, scrollPosition: .middle)
        self.currentPlayingAudioIndex = section + 1
        playAudio(item: audioList[section + 1])
    }
    
    private func setUpLanguage() {
        navBarTitleLabel.text = "cs_background_music_title".localized
        noDataLabel.text = "common_no_items_to_show".localized
        albumNameLabel.text = ""
        audioNameLabel.text = "cs_background_music_not_playing".localized
        artistNameLabel.text = ""
    }
    
    private func setUpTableView() {
        tableView.register(CSAudioTableViewCell.nib(),
                           forCellReuseIdentifier: CSAudioTableViewCell.identifier)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
    }
    
    private func setUpNavBar() {
        shouldShowNavbar = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func loadData(page: Int) {
        guard let subCategory = subCategory else {
            self.canContinueToNextPage = false
            self.progressActivityIndicator.stopAnimating()
            self.tableView.reloadData()
            return
        }
        CSPresenter.backgroundSound.getSounds(of: subCategory, page: page)
            .done { (response) in
                self.canContinueToNextPage = response.next != nil
                self.audioList.append(contentsOf: response.results)
            }
            .ensure {
                self.progressActivityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
            .cauterize()
    }
    
    private func loadPreviewImage() {
        guard let coverImage = coverImage else { return }
        audioCoverImageView.load(url: coverImage.imageUrl)
    }
    
    private func loadPlayerCallbacks() {
        if AudioPlayer.shared.isPlaying {
            artistNameLabel.text = AudioPlayer.shared.author
            audioNameLabel.text = AudioPlayer.shared.title
            albumNameLabel.text = AudioPlayer.shared.album
            playPauseButton.isEnabled = true
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        }
        AudioPlayer.shared.didUpdateProgress = { [weak self] value in
            self?.audioProgressView.setProgress(Float(value), animated: true)
        }
        
        AudioPlayer.shared.didUpdatePlayPause = { [weak self] isPlaying in
            self?.playPauseButton.setImage(UIImage(named: isPlaying ? "pause" : "play"), for: .normal)
        }
    }
    
    private func playAudio(item: BackgroundAudio) {
        AudioPlayer.shared.stop()
        currentPlayingAudio = item
        AudioPlayer.shared.load(item: item)
        audioNameLabel.text = item.name
        albumNameLabel.text = item.album
        artistNameLabel.text = item.author
    }
}

extension CSSoundListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CSAudioTableViewCell.height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        noDataLabel.isHidden = !(audioList.count == 0 && !canContinueToNextPage)
        return audioList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let mainCell = tableView.dequeueReusableCell(withIdentifier: CSAudioTableViewCell.identifier),
           let cell = mainCell as? CSAudioTableViewCell {
            cell.setUpAudio(file: audioList[indexPath.section])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
        
        if canContinueToNextPage {
            if indexPath.section == audioList.count - 1 { loadData(page: page + 1) }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPlayingAudioIndex = indexPath.section
        playAudio(item: audioList[indexPath.section])
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
extension CSSoundListViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let audioUrl = urls.first,
           let subCategory = CreateStoryObject.shared?.subCategory {
            var fileExtension = FileType.audioMp3
            switch audioUrl.pathExtension {
            case "m4a":
                fileExtension = .audioM4a
            case "mp3":
                fileExtension = .audioMp3
            default:
                return
            }
            let tempFile = LocalFile(url: audioUrl.absoluteString,
                                     fileType: fileExtension)
            tempFile.upload()
            tableView.isHidden = true
            noDataLabel.isHidden = true
            uploadActivityIndicator.startAnimating()
            tempFile.finishedUpload = { [weak self] soundId in
                CSPresenter.backgroundSound.createSound(subCategoryId: subCategory.id,
                                                        sound: soundId,
                                                        name: tempFile.name)
                    .done({ (_) in
                        self?.performSegue(withIdentifier: "showAlert", sender: nil)
                    })
                    .ensure {
                        self?.tableView.isHidden = false
                        self?.tableView.reloadData()
                        self?.uploadActivityIndicator.stopAnimating()
                    }
                    .cauterize()
            }
        }
    }
}
