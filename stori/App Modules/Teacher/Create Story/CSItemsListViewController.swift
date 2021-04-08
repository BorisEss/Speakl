//
//  CSItemsListViewController.swift
//  stori
//
//  Created by Alex on 26.01.2021.
//

import UIKit
import PromiseKit
import PaginatedTableView
import TableFlip

class CSItemsListViewController: UIViewController {

    var listType: CSListType?
    lazy var topic: Topic? = CreateStoryObject.shared?.topic
    lazy var category: Category? = CreateStoryObject.shared?.category
    lazy var language: Language? = CreateStoryObject.shared?.language
    
    private lazy var itemList: [ItemProtocol] = []
    private lazy var languageList: [Language] = []
    private lazy var languageLevelList: [LanguageLevel] = []
        
    @IBOutlet weak var tableView: PaginatedTableView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var progressActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLangauge()
        setUpTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let index = tableView.indexPathForSelectedRow else { return }
        guard let listType = listType else { return }
        switch listType {
        case .topic:
            CreateStoryObject.shared?.topic = itemList[index.row] as? Topic
        case .category:
            CreateStoryObject.shared?.category = itemList[index.row] as? Category
        case .subCategory:
            CreateStoryObject.shared?.subCategory = itemList[index.row] as? SubCategory
        case .language:
            CreateStoryObject.shared?.language = languageList[index.row]
        case .languageLevel:
            guard let storyId = CreateStoryObject.shared?.id else { return }
            if CreateStoryObject.shared?.chapter == nil {
                CSPresenter.chapter.createChapter(storyId: storyId,
                                                  languageLevelId: languageLevelList[index.row].id)
                    .done { (chapter) in
                        CreateStoryObject.shared?.chapter = chapter
                    }
                    .cauterize()
            } else {
                guard let chapterId = CreateStoryObject.shared?.chapter?.id else { return }
                CSPresenter.chapter.updateChapter(chapterId: chapterId,
                                                  languageLevelId: languageLevelList[index.row].id)
                    .done { (chapter) in
                        CreateStoryObject.shared?.chapter = chapter
                    }
                    .cauterize()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVc = segue.destination as? CSCustomItemViewController {
            nextVc.title = title
            nextVc.listType = listType
        }
    }
    
    private func setUpLangauge() {
        if let listType = listType {
            switch listType {
            case .topic:
                title = "cs_main_list_topic_title".localized
            case .category:
                title = "cs_main_list_category_title".localized
            case .subCategory:
                title = "cs_main_list_sub_category_title".localized
            case .language:
                title = "cs_main_list_language_title".localized
            case .languageLevel:
                title = "cs_main_list_language_level_title".localized
            }
        }
        noDataLabel.text = "common_no_items_to_show".localized
    }
    
    private func setUpTableView() {
        tableView.register(CSItemTableViewCell.nib(),
                           forCellReuseIdentifier: CSItemTableViewCell.identifier)
        tableView.paginatedDelegate = self
        tableView.paginatedDataSource = self
        tableView.enablePullToRefresh = false
        tableView.loadData(refresh: true)
        
    }
    
    private func loadData(listType: CSListType, page: Int) -> Promise<(items: [ItemProtocol], canContinue: Bool)> {
        return Promise<(items: [ItemProtocol], canContinue: Bool)> { promise in
            switch listType {
            case .topic:
                loadTopics(page: page)
                    .done { (response) in
                        promise.fulfill((items: response.results, canContinue: response.next != nil))
                    }
                    .catch { (error) in
                        promise.reject(error)
                    }
            case .category:
                loadCategories(page: page)
                    .done { (response) in
                        promise.fulfill((items: response.results, canContinue: response.next != nil))
                    }.catch { (error) in
                        promise.reject(error)
                    }
            case .subCategory:
                loadSubCategories(page: page)
                    .done { (response) in
                        promise.fulfill((items: response.results, canContinue: response.next != nil))
                    }
                    .catch { (error) in
                        promise.reject(error)
                    }
            case .language, .languageLevel:
                promise.reject(NetworkError.notFound)
            }
        }
    }
    
    private func loadTopics(page: Int) -> Promise<ResponseObject<Topic>> {
        guard let language = CreateStoryObject.shared?.language else {
            return Promise<ResponseObject<Topic>> { promise in
                promise.reject(NetworkError.requestBuilderFailed)
            }
        }
        return CSPresenter.topic.getTopics(for: language, page: page)
    }
    private func loadCategories(page: Int) -> Promise<ResponseObject<Category>> {
        guard let category = topic,
              let language = language else {
            return Promise<ResponseObject<Category>> { promise in
                promise.reject(NetworkError.requestBuilderFailed)
            }
        }
        return CSPresenter.category.getCategories(of: category, with: language, page: page)
    }
    private func loadSubCategories(page: Int) -> Promise<ResponseObject<SubCategory>> {
        guard let subCategory = category,
              let language = language else {
            return Promise<ResponseObject<SubCategory>> { promise in
                promise.reject(NetworkError.requestBuilderFailed)
            }
        }
        return CSPresenter.subCategory.getSubCategories(of: subCategory, with: language, page: page)
    }
    private func loadLanguages() -> Promise<[Language]> {
        return Promise<[Language]> { promise in
            promise.fulfill(Storage.shared.languages)
        }
    }
    private func loadLangaugeLevels() -> Promise<[LanguageLevel]> {
        guard let language = CreateStoryObject.shared?.language else {
            return Promise<[LanguageLevel]> { promise in
                promise.reject(NetworkError.requestBuilderFailed)
            }
        }
        return CSPresenter.languageLevel.getLanguageLevels(language: language)
    }
    private func checkAndSelectItem() {
        guard tableView.indexPathForSelectedRow == nil else { return }
        guard let listType = listType else { return }
        switch listType {
        case .topic:
            checkItem(item: topic)
        case .category:
            checkItem(item: category)
        case .subCategory:
            checkItem(item: CreateStoryObject.shared?.subCategory)
        case .language:
            checkLanguage()
        case .languageLevel:
            checkLanguageLevel()
        }
    }
    private func checkItem(item: ItemProtocol?) {
        guard let item = item,
              let firstIndex = itemList.firstIndex(where: {$0.id == item.id}) else { return }
        tableView.selectRow(at: IndexPath(row: firstIndex, section: 0),
                            animated: false, scrollPosition: .none)
    }
    private func checkLanguage() {
        guard let language = language,
              let firstIndex = languageList.firstIndex(where: {$0.id == language.id}) else { return }
        tableView.selectRow(at: IndexPath(row: firstIndex, section: 0),
                            animated: false, scrollPosition: .none)
    }
    private func checkLanguageLevel() {
        guard let languageLevel = CreateStoryObject.shared?.chapter?.languageLevel,
              let firstIndex = languageLevelList.firstIndex(where: {$0.id == languageLevel.id}) else { return }
        tableView.selectRow(at: IndexPath(row: firstIndex, section: 0),
                            animated: false, scrollPosition: .none)
    }
}

extension CSItemsListViewController: PaginatedTableViewDelegate, PaginatedTableViewDataSource {
    func loadMore(_ pageNumber: Int, _ pageSize: Int, onSuccess: ((Bool) -> Void)?, onError: ((Error) -> Void)?) {
        guard let listType = listType else {
            progressActivityIndicator.stopAnimating()
            noDataLabel.isHidden = false
            return
        }
        noDataLabel.isHidden = true
        switch listType {
        case .topic, .category, .subCategory:
            loadData(listType: listType, page: pageNumber)
                .ensure { self.progressActivityIndicator.stopAnimating() }
                .done { (response) in
                    if pageNumber == 1 {
                        self.itemList = []
                        if response.items.isEmpty { self.noDataLabel.isHidden = false }
                    }
                    self.itemList.append(contentsOf: response.items)
                    onSuccess?(response.canContinue)
                    if pageNumber == 1 {
                        self.tableView.animate(animation: TableViewAnimation.Cell.right(duration: 1))
                    }
                    self.checkAndSelectItem()
                }.cauterize()
        case .language:
            loadLanguages()
                .ensure { self.progressActivityIndicator.stopAnimating() }
                .done { (languages) in
                    if languages.isEmpty { self.noDataLabel.isHidden = false }
                    self.languageList = languages
                    onSuccess?(false)
                    self.tableView.animate(animation: TableViewAnimation.Cell.right(duration: 1))
                    self.checkAndSelectItem()
                }.cauterize()
        case .languageLevel:
            loadLangaugeLevels()
                .ensure { self.progressActivityIndicator.stopAnimating() }
                .done { (levels) in
                    if levels.isEmpty { self.noDataLabel.isHidden = false }
                    self.languageLevelList = levels
                    onSuccess?(false)
                    self.tableView.animate(animation: TableViewAnimation.Cell.right(duration: 1))
                    self.checkAndSelectItem()
                }.cauterize()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CSItemTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let listType = listType else {
            noDataLabel.isHidden = false
            return 0
        }
        switch listType {
        case .topic, .category, .subCategory:
            return itemList.count
        case .language:
            return languageList.count
        case .languageLevel:
            return languageLevelList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let mainCell = tableView.dequeueReusableCell(withIdentifier: CSItemTableViewCell.identifier),
           let cell = mainCell as? CSItemTableViewCell,
           let listType = listType {
            switch listType {
            case .topic:
                cell.setTitleAndImage(title: itemList[indexPath.row].name,
                                      image: itemList[indexPath.row].image ?? "")
            case .category, .subCategory:
                cell.setTitle(itemList[indexPath.row].name)
            case .language:
                cell.setLanguage(language: languageList[indexPath.row])
            case .languageLevel:
                cell.setLanguageLevel(level: languageLevelList[indexPath.row])
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }

}
