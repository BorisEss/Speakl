//
//  CSSoundListSearchViewController.swift
//  stori
//
//  Created by Alex on 27.01.2021.
//

import UIKit
import PromiseKit
import TableFlip
import PaginatedTableView

class CSSoundListSearchViewController: UIViewController {
    
    var coverImage: CoverImage?
    var currentPlayingAudio: BackgroundAudio?
    var completion: ((BackgroundAudio) -> Void)?
    var updateSongOnPreviousScreen: ((BackgroundAudio) -> Void)?

    private var audioList: [BackgroundAudio] = []
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var tableView: PaginatedTableView!
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
        tableView.paginatedDelegate = self
        tableView.paginatedDataSource = self
        tableView.register(CSAudioTableViewCell.nib(),
                           forCellReuseIdentifier: CSAudioTableViewCell.identifier)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 80))
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
        tableView.loadData(refresh: true)
    }
    
    private func getData(page: Int) -> Promise<ResponseObject<BackgroundAudio>> {
        if let text = searchTextField.text,
           text.count >= 3 {
            return CSPresenter.backgroundSound.searchSounds(searchText: text, page: page)
        } else {
            return CSPresenter.backgroundSound.getAllSounds(page: page)
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

extension CSSoundListSearchViewController: PaginatedTableViewDelegate, PaginatedTableViewDataSource {
    func loadMore(_ pageNumber: Int, _ pageSize: Int, onSuccess: ((Bool) -> Void)?, onError: ((Error) -> Void)?) {
        noDataLabel.isHidden = true
        self.getData(page: pageNumber)
            .ensure {
                self.progressActivityIndicator.stopAnimating()
            }
            .done { (response) in
                let canLoadMore: Bool = response.next != nil
                if pageNumber == 1 {
                    self.audioList = []
                    if response.results.isEmpty {
                        self.noDataLabel.isHidden = false
                    }
                }
                self.audioList.append(contentsOf: response.results)
                onSuccess?(canLoadMore)
                if pageNumber == 1 {
                    self.tableView.animate(animation: TableViewAnimation.Cell.fade(duration: 1))
                }
            }
            .catch { (error) in
                print(error.localizedDescription)
                if pageNumber == 1 {
                    self.noDataLabel.isHidden = false
                }
                onSuccess?(false)
            }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CSAudioTableViewCell.height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saveButton.isHidden = false
        playPauseButton.isEnabled = true
        playAudio(item: audioList[indexPath.section])
    }
}

extension CSSoundListSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text,
           text.count > 3 {
            tableView.loadData(refresh: true)
        } else if let text = textField.text, text.isEmpty {
            tableView.loadData(refresh: true)
        }
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        tableView.loadData(refresh: true)
        return true
    }
}
