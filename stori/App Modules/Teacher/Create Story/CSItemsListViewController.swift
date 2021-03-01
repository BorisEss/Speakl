//
//  CSItemsListViewController.swift
//  stori
//
//  Created by Alex on 26.01.2021.
//

import UIKit
import PromiseKit

class CSItemsListViewController: UIViewController {

    var listType: CSListType?
    var topic: Topic? = CreateStoryObject.shared?.topic
    var category: Category? = CreateStoryObject.shared?.category
    var language: Language? = CreateStoryObject.shared?.language 
    
    private var itemList: [ItemProtocol] = []
    private var languageList: [Language] = []
    private var languageLevelList: [LanguageLevel] = []
    
    private var page: Int = 1
    private var canContinueToNextPage: Bool = true
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var progressActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLangauge()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        itemList = []
        languageList = []
        languageLevelList = []
        loadData(page: page)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let index = tableView.indexPathForSelectedRow else { return }
        guard let listType = listType else { return }
        switch listType {
        case .topic:
            CreateStoryObject.shared?.topic = itemList[index.section] as? Topic
        case .category:
            CreateStoryObject.shared?.category = itemList[index.section] as? Category
        case .subCategory:
            CreateStoryObject.shared?.subCategory = itemList[index.section] as? SubCategory
        case .language:
            CreateStoryObject.shared?.language = languageList[index.section]
        case .languageLevel:
            guard let storyId = CreateStoryObject.shared?.id else {
                return
            }
            if CreateStoryObject.shared?.chapter == nil {
                CSPresenter.chapter.createChapter(storyId: storyId,
                                                  languageLevelId: languageLevelList[index.section].id)
                    .done { (chapter) in
                        CreateStoryObject.shared?.chapter = chapter
                    }
                    .cauterize()
            } else {
                guard let chapterId = CreateStoryObject.shared?.chapter?.id else { return }
                CSPresenter.chapter.updateChapter(chapterId: chapterId,
                                                  languageLevelId: languageLevelList[index.section].id)
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
    }
    
    private func loadData(page: Int) {
        guard let listType = listType else {
            self.canContinueToNextPage = false
            self.progressActivityIndicator.stopAnimating()
            self.tableView.reloadData()
            return
        }
        self.page = page
        switch listType {
        case .topic:
            loadTopics()
        case .category:
            loadCategories()
        case .subCategory:
            loadSubCategories()
        case .language:
            loadLanguages()
        case .languageLevel:
            loadLangaugeLevels()
        }
    }
    
    private func loadTopics() {
        guard let language = CreateStoryObject.shared?.language else { return }
        CSPresenter.topic.getTopics(for: language, page: page)
            .done { (response) in
                self.canContinueToNextPage = response.next != nil
                self.itemList.append(contentsOf: response.results)
            }
            .ensure {
                self.progressActivityIndicator.stopAnimating()
                self.tableView.reloadData()
                self.checkAndSelectItem()
            }
            .cauterize()
    }
    private func loadCategories() {
        guard let category = topic else {
            self.canContinueToNextPage = false
            self.progressActivityIndicator.stopAnimating()
            self.tableView.reloadData()
            return
        }
        CSPresenter.category.getCategories(of: category, page: page)
            .done { (response) in
                self.canContinueToNextPage = response.next != nil
                self.itemList.append(contentsOf: response.results)
            }
            .ensure {
                self.progressActivityIndicator.stopAnimating()
                self.tableView.reloadData()
                self.checkAndSelectItem()
            }
            .cauterize()
    }
    private func loadSubCategories() {
        guard let subCategory = category else {
            self.canContinueToNextPage = false
            self.progressActivityIndicator.stopAnimating()
            self.tableView.reloadData()
            return
        }
        CSPresenter.subCategory.getSubCategories(of: subCategory, page: page)
            .done { (response) in
                self.canContinueToNextPage = response.next != nil
                self.itemList.append(contentsOf: response.results)
            }
            .ensure {
                self.progressActivityIndicator.stopAnimating()
                self.tableView.reloadData()
                self.checkAndSelectItem()
            }
            .cauterize()
    }
    private func loadLanguages() {
        canContinueToNextPage = false
        languageList = Storage.shared.languages
        tableView.reloadData()
        checkAndSelectItem()
        progressActivityIndicator.stopAnimating()
    }
    private func loadLangaugeLevels() {
        guard let language = language else {
            self.canContinueToNextPage = false
            self.progressActivityIndicator.stopAnimating()
            self.tableView.reloadData()
            return
        }
        CSPresenter.languageLevel.getLanguageLevels(language: language)
            .done { (response) in
                self.canContinueToNextPage = false
                self.languageLevelList.append(contentsOf: response)
            }
            .ensure {
                self.progressActivityIndicator.stopAnimating()
                self.tableView.reloadData()
                self.checkAndSelectItem()
            }
            .cauterize()
    }
    private func checkAndSelectItem() {
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
        tableView.selectRow(at: IndexPath(row: 0, section: firstIndex),
                            animated: false, scrollPosition: .none)
    }
    private func checkLanguage() {
        guard let language = language,
              let firstIndex = languageList.firstIndex(where: {$0.id == language.id}) else { return }
        tableView.selectRow(at: IndexPath(row: 0, section: firstIndex),
                            animated: false, scrollPosition: .none)
    }
    private func checkLanguageLevel() {
        guard let languageLevel = CreateStoryObject.shared?.chapter?.languageLevel,
              let firstIndex = languageLevelList.firstIndex(where: {$0.id == languageLevel.id}) else { return }
        tableView.selectRow(at: IndexPath(row: 0, section: firstIndex),
                            animated: false, scrollPosition: .none)
    }
}

extension CSItemsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CSItemTableViewCell.height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let listType = listType else {
            noDataLabel.isHidden = false
            return 0
        }
        switch listType {
        case .topic, .category, .subCategory:
            noDataLabel.isHidden = !(itemList.count == 0 && !canContinueToNextPage)
            return itemList.count
        case .language:
            noDataLabel.isHidden = !(languageList.count == 0 && !canContinueToNextPage)
            return languageList.count
        case .languageLevel:
            noDataLabel.isHidden = !(languageLevelList.count == 0 && !canContinueToNextPage)
            return languageLevelList.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let mainCell = tableView.dequeueReusableCell(withIdentifier: CSItemTableViewCell.identifier),
           let cell = mainCell as? CSItemTableViewCell,
           let listType = listType {
            switch listType {
            case .topic:
                cell.setTitleAndImage(title: itemList[indexPath.section].name,
                                      image: itemList[indexPath.section].image ?? "")
            case .category, .subCategory:
                cell.setTitle(itemList[indexPath.section].name)
            case .language:
                cell.setLanguage(language: languageList[indexPath.section])
            case .languageLevel:
                cell.setLanguageLevel(level: languageLevelList[indexPath.section])
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
        
        if canContinueToNextPage,
           let listType = listType {
            switch listType {
            case .topic, .category, .subCategory:
                if indexPath.section == itemList.count - 1 { loadData(page: page + 1) }
            case .language, .languageLevel:
                break
            }
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
