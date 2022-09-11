//
//  GrammarSubcategoryDetailsViewController.swift
//  stori
//
//  Created by Alex on 20.07.2022.
//

import UIKit
import SpreadsheetView

class GrammarSubcategoryDetailsViewController: UIViewController {

    var id: String?
    private var subcategoryDetails: GrammarSubcategoryDetails? {
        didSet {
            if let subcategoryDetails = subcategoryDetails {
                setUpTable(subcategoryDetails)
            }
        }
    }
    private var navbarWasHidden: Bool = false
    
    @IBOutlet weak var progressActivityIndicator: AppActivityIndicator!
    @IBOutlet weak var contentStackView: UIStackView!
    
    @IBOutlet weak var explanationView: UIView!
    @IBOutlet weak var explanationLabel: UILabel!
    
    @IBOutlet weak var storiesView: UIView!
    @IBOutlet weak var storiesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        storiesCollectionView.register(StoryCollectionViewCell.nib(),
                                       forCellWithReuseIdentifier: StoryCollectionViewCell.identifier)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        guard let id = id else { return }
        progressActivityIndicator.startAnimating()
        GrammarService().getSubcategoryDetails(for: id)
            .ensure {
                self.progressActivityIndicator.stopAnimating()
            }
            .done { subcategoryDetails in
                self.subcategoryDetails = subcategoryDetails
                self.explanationView.isHidden = subcategoryDetails.description.isEmpty
                self.explanationLabel.text = subcategoryDetails.description
                self.storiesView.isHidden = subcategoryDetails.stories.isEmpty
                if !subcategoryDetails.stories.isEmpty {
                    self.storiesCollectionView.reloadData()
                }
            }
            .catch { error in
                error.parse()
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if navigationController?.navigationBar.isHidden ?? false {
            navbarWasHidden = true
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if navbarWasHidden, self.isMovingFromParent {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let minimumInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        storiesCollectionView.centerContentHorizontalyByInsetIfNeeded(minimumInset: minimumInset)
    }
    
    private func setUpTable(_ details: GrammarSubcategoryDetails) {
        switch details.tableData.tableType {
        case .twoColumns: loadTwoColumnsTableView()
        case .twoColumnsWithTitle: loadTwoColumnsWithTitleTableView()
        case .threeColumns: loadThreeColumnsTableView()
        case .fourColumns: loadFourColumnsTableView()
        case .twoColumnsGrouped: loadTwoColumnsGrouppedTableView()
        }
    }
    
    private func loadTwoColumnsTableView() {
        guard let subcategoryDetails = subcategoryDetails else { return }
        let table = TwoColumnsTableView(width: view.frame.width, data: subcategoryDetails.tableData)
        table.heightAnchor.constraint(equalToConstant: table.tableHeight).isActive = true
        table.didSelectItem = { item in
            Toast.success(item)
        }
        contentStackView.insertArrangedSubview(table, at: 1)
    }
    
    private func loadTwoColumnsWithTitleTableView() {
        guard let subcategoryDetails = subcategoryDetails else { return }
        let table = TwoColumnsWithTitleTableView(width: view.frame.width,
                                                 data: subcategoryDetails.tableData)
        table.heightAnchor.constraint(equalToConstant: table.tableHeight).isActive = true
        table.didSelectItem = { item in
            Toast.success(item)
        }
        contentStackView.insertArrangedSubview(table, at: 1)
    }
    
    private func loadThreeColumnsTableView() {
        guard let subcategoryDetails = subcategoryDetails else { return }
        let table = ThreeColumnsTableView(width: view.frame.width,
                                          data: subcategoryDetails.tableData)
        table.heightAnchor.constraint(equalToConstant: table.tableHeight).isActive = true
        table.didSelectItem = { item in
            Toast.success(item)
        }
        contentStackView.insertArrangedSubview(table, at: 1)
    }
    
    private func loadFourColumnsTableView() {
        guard let subcategoryDetails = subcategoryDetails else { return }
        let table = FourColumnsTableView(width: view.frame.width,
                                          data: subcategoryDetails.tableData)
        table.heightAnchor.constraint(equalToConstant: table.tableHeight).isActive = true
        table.didSelectItem = { item in
            Toast.success(item)
        }
        contentStackView.insertArrangedSubview(table, at: 1)
    }
    
    private func loadTwoColumnsGrouppedTableView() {
        guard let subcategoryDetails = subcategoryDetails else { return }
        let table = TwoColumnsGrouppedTableView(width: view.frame.width,
                                          data: subcategoryDetails.tableData)
        table.heightAnchor.constraint(equalToConstant: table.tableHeight).isActive = true
        table.didSelectItem = { item in
            Toast.success(item)
        }
        contentStackView.insertArrangedSubview(table, at: 1)
    }
}

extension GrammarSubcategoryDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let subcategoryDetails = subcategoryDetails {
            return subcategoryDetails.stories.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionViewCell.identifier,
                                                          for: indexPath)
        if let cell = mainCell as? StoryCollectionViewCell {
            cell.cellHeightConstraint.constant = collectionView.frame.height
            cell.layoutIfNeeded()
            return cell
        }
        return mainCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Learn", bundle: nil)
        let nextScreen = storyBoard.instantiateViewController(withIdentifier: "MainStoryVideoListViewController")
        if let unwrappedNextScreen = nextScreen as? MainStoryVideoListViewController {
            unwrappedNextScreen.position = 0
            navigationController?.pushViewController(unwrappedNextScreen, animated: true)
        }
    }
}
