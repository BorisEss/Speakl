//
//  CSSoundListSearchViewController.swift
//  stori
//
//  Created by Alex on 27.01.2021.
//

import UIKit
import PromiseKit

class CSSoundListSearchViewController: UIViewController {
    
    var coverImage: CoverImage?
    var currentPlayingAudio: BackgroundAudio?
    var completion: ((BackgroundAudio) -> Void)?
    var updateSongOnPreviousScreen: ((BackgroundAudio) -> Void)?

    private var audioList: [BackgroundAudio] = []
    
    private var page: Int = 1
    private var canContinueToNextPage: Bool = true
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var progressActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var audioCoverImageView: UIImageView!
    @IBOutlet weak var audioProgressView: UIProgressView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var audioTitleLabel: UILabel!
    @IBOutlet weak var audioArtistLabel: UILabel!
    
    @IBOutlet weak var saveButton: RegularButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLanguage()
        setUpTableView()
        loadPreviewImage()
        loadPlayerCallbacks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        audioList = []
        loadData(page: page)
        if let currentPlayingAudio = currentPlayingAudio {
            audioTitleLabel.text = currentPlayingAudio.name
        }
        if AudioPlayer.shared.isPlaying {
            audioArtistLabel.text = AudioPlayer.shared.author
            audioTitleLabel.text = AudioPlayer.shared.title
            playPauseButton.isEnabled = true
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        }
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        guard let selected = tableView.indexPathForSelectedRow else { return }
        updateSongOnPreviousScreen?(audioList[selected.section])
    }
    
    @IBAction func playPausePressed(_ sender: Any) {
        AudioPlayer.shared.togglePlayPause()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let selected = tableView.indexPathForSelectedRow else { return }
        completion?(audioList[selected.section])
        AudioPlayer.shared.stop()
        dismiss(animated: true, completion: nil)
    }
    
    private func setUpLanguage() {
        searchTextField.placeholder = "cs_background_music_search_placehodler".localized
        cancelButton.setTitle("common_cancel_title".localized, for: .normal)
        saveButton.setTitle("common_save".localized, for: .normal)
        audioTitleLabel.text = "cs_background_music_not_playing".localized
        audioArtistLabel.text = ""
        noDataLabel.text = "common_no_results_message".localized
    }
    
    private func setUpTableView() {
        tableView.register(CSAudioTableViewCell.nib(),
                           forCellReuseIdentifier: CSAudioTableViewCell.identifier)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 80))
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
    }
    
    private func loadData(page: Int) {
        audioList = []
        CSPresenter.backgroundSound.getAllSounds(page: page)
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
    private func searchSongs(page: Int) {
        if page == 1 { canContinueToNextPage = true }
        audioList = []
        if let text = searchTextField.text,
           text.count >= 3 {
            CSPresenter.backgroundSound.searchSounds(searchText: text, page: page)
                .done { (response) in
                    self.canContinueToNextPage = response.next != nil
                    self.audioList.append(contentsOf: response.results)
                }
                .ensure {
                    self.progressActivityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
                .cauterize()
        } else {
            canContinueToNextPage = false
            tableView.reloadData()
        }
    }
    
    private func loadPreviewImage() {
        guard let coverImage = coverImage else { return }
        audioCoverImageView.load(url: coverImage.imageUrl)
    }
    
    private func loadPlayerCallbacks() {
        AudioPlayer.shared.didUpdateProgress = { [weak self] progress in
            self?.audioProgressView.setProgress(Float(progress), animated: true)
        }
        AudioPlayer.shared.didUpdatePlayPause = { [weak self] isPlaying in
            self?.playPauseButton.isEnabled = true
            self?.playPauseButton.setImage(UIImage(named: isPlaying ? "pause" : "play"), for: .normal)
        }
    }
    
    private func playAudio(item: BackgroundAudio) {
        AudioPlayer.shared.stop()
        currentPlayingAudio = item
        AudioPlayer.shared.load(item: item)
        audioTitleLabel.text = item.name
        audioArtistLabel.text = item.author
    }
}

extension CSSoundListSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        if canContinueToNextPage,
           indexPath.section == audioList.count - 1 {
            if searchTextField.text?.isEmpty ?? false {
                loadData(page: page + 1)
            } else {
                searchSongs(page: page + 1)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saveButton.isHidden = false
        playPauseButton.isEnabled = true
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

extension CSSoundListSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        searchSongs(page: page)
        return true
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchSongs(page: page)
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        loadData(page: 1)
        return true
    }
}
