//
//  LanguageInterestsSelectionViewController.swift
//  stori
//
//  Created by Alex on 14.12.2020.
//

import UIKit
import PromiseKit

class LanguageInterestsSelectionViewController: UIViewController {

    // MARK: - Internal proprietes
    var nativeLanguage: Language?
    var learningLanguage: Language?
    var selectedLevel: LanguageLevel?
    var interests: [Interest] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var progressActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: RegularButton!
    @IBOutlet weak var nextProgressActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpLanguage()
        
        guard let learningLanguage = learningLanguage else { return }
        LanguagePresenter().getInterests(for: learningLanguage)
            .done { (interests) in
                self.interests = interests
            }
            .ensure {
                self.progressActivityIndicator.stopAnimating()
            }
            .cauterize()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Button Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        var selectedInterests: [Interest] = []
        if let indexes = collectionView.indexPathsForSelectedItems {
            for index in indexes {
                selectedInterests.append(interests[index.row])
            }
        }
        collectionView.isUserInteractionEnabled = false
        nextProgressActivityIndicator.startAnimating()
        nextButton.isHidden = true
        LanguagePresenter().updateLanguageDetails(nativeLanguage: nativeLanguage,
                                                  learningLanguage: learningLanguage,
                                                  learningLanguageLevel: selectedLevel,
                                                  interests: selectedInterests) { (isSuccess) in
            self.collectionView.isUserInteractionEnabled = true
            self.nextProgressActivityIndicator.stopAnimating()
            self.nextButton.isHidden = false
            if isSuccess {
                Router.load()
            }
        }
    }
    
    // MARK: - UI Setup
    private func setUpView() {
        setUpCollectionView()
    }
    
    private func setUpCollectionView() {
        collectionView.register(InterestCollectionViewCell.nib(),
                                forCellWithReuseIdentifier: InterestCollectionViewCell.identifier)
        collectionView.allowsMultipleSelection = true
    }
    
    private func setUpLanguage() {
        titleLabel.text = "select_interests_vc_page_title".localized
        subtitleLabel.text = "select_interests_vc_page_subtitle".localized
        nextButton.setTitle("select_interests_vc_next_button".localized, for: .normal)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension LanguageInterestsSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interests.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InterestCollectionViewCell.identifier,
                                                         for: indexPath) as? InterestCollectionViewCell {
            cell.setUp(interest: interests[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        checkSelectedItems()
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        checkSelectedItems()
    }
    
    private func checkSelectedItems() {
        nextButton.isEnabled = !(collectionView.indexPathsForSelectedItems?.isEmpty ?? true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LanguageInterestsSelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 10) / 2
        return CGSize(width: width, height: InterestCollectionViewCell.height)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 100)
    }
}
