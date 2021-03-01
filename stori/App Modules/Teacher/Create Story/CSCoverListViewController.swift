//
//  CSCoverListViewController.swift
//  stori
//
//  Created by Alex on 27.01.2021.
//

import UIKit
import VerticalCardSwiper
import NVActivityIndicatorView

class CSCoverListViewController: UIViewController {
    
    var completion: ((CoverImage) -> Void)?
    
    var category: Topic? = CreateStoryObject.shared?.topic
    var subCategory: SubCategory? = CreateStoryObject.shared?.subCategory

    private var cardSwiper: VerticalCardSwiper!
    private var images: [CoverImage] = []
    
    private var page: Int = 1
    private var canContinueToNextPage: Bool = true
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var progressActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var uploadingActivityIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLanguage()
        setUpCards()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        images = []
        loadData(page: page)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVc = segue.destination as? CSCustomItemPopUpViewController {
            nextVc.descriptionText = "cs_covers_custom_popup".localized
        }
    }
    
    private func setUpLanguage() {
        title = "cs_covers_title".localized
        noDataLabel.text = "common_no_items_to_show".localized
    }

    private func setUpCards() {
        let navbarHeight = navigationController?.navigationBar.frame.maxY ?? 0
        let cardSwiperFrame = CGRect(x: 0,
                                     y: navbarHeight,
                                     width: view.frame.width,
                                     height: view.frame.height - navbarHeight)
        cardSwiper = VerticalCardSwiper(frame: cardSwiperFrame)
        view.addSubview(cardSwiper)
        cardSwiper.backgroundColor = .clear
        cardSwiper.isSideSwipingEnabled = false
        cardSwiper.topInset = 26
        cardSwiper.sideInset = 25
        cardSwiper.delegate = self
        cardSwiper.datasource = self
        cardSwiper.register(nib: CSCoverCardCell.nib(),
                            forCellWithReuseIdentifier: CSCoverCardCell.identifier)
        cardSwiper.clipsToBounds = false
    }
    
    private func loadData(page: Int) {
        guard let subCategory = subCategory else {
            self.canContinueToNextPage = false
            self.progressActivityIndicator.stopAnimating()
            self.cardSwiper.reloadData()
            return
        }
        CSPresenter.cover.getCovers(of: subCategory, page: page)
            .done { (response) in
                self.canContinueToNextPage = response.next != nil
                self.images.append(contentsOf: response.results)
                self.page = page
            }
            .ensure {
                self.progressActivityIndicator.stopAnimating()
                self.cardSwiper.reloadData()
            }
            .cauterize()
    }
    @IBAction func addCustomImageDidSelect(_ sender: Any) {
        ImagePicker.pickImage(from: .library, frontCamera: false) { [weak self] (file) in
            guard let subCategory = CreateStoryObject.shared?.subCategory else { return }
            file.upload()
            self?.cardSwiper.isHidden = true
            self?.uploadingActivityIndicator.isHidden = false
            self?.uploadingActivityIndicator.startAnimating()
            self?.noDataLabel.alpha = 0
            self?.addButton.isEnabled = false
            file.finishedUpload = { [weak self] fileId in
                CSPresenter.cover.createCover(subCategoryId: subCategory.id, cover: fileId)
                    .done { (_) in
                        self?.performSegue(withIdentifier: "showAlert", sender: nil)
                    }
                    .ensure {
                        self?.cardSwiper.isHidden = false
                        self?.uploadingActivityIndicator.isHidden = true
                        self?.uploadingActivityIndicator.stopAnimating()
                        self?.noDataLabel.alpha = 1
                        self?.addButton.isEnabled = true
                        self?.canContinueToNextPage = true
                        self?.images = []
                        self?.loadData(page: 1)
                    }
                    .cauterize()
            }
        }
    }
}

extension CSCoverListViewController: VerticalCardSwiperDelegate, VerticalCardSwiperDatasource {
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        noDataLabel.isHidden = !(images.count == 0 && !canContinueToNextPage)
        return images.count
    }
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        if let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: CSCoverCardCell.identifier,
                                                                     for: index) as? CSCoverCardCell {
            cardCell.setImage(image: images[index],
                              topic: category,
                              subCategory: subCategory)
            cardCell.didSelect = { image in
                CreateStoryObject.shared?.chapter?.cover = image
                self.navigationController?.popViewController(animated: true)
                self.completion?(image)
            }
            return cardCell
        }
        return CardCell()
    }
    
    func didEndScroll(verticalCardSwiperView: VerticalCardSwiperView) {
        if canContinueToNextPage {
            loadData(page: page + 1)
        }
    }
}
