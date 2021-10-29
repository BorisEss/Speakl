//
//  CSMainListViewController.swift
//  stori
//
//  Created by Alex on 25.01.2021.
//

import UIKit

enum CSListType {
    case topic
    case category
    case subCategory
    case language
    case languageLevel
}

class CSMainListViewController: UIViewController {
    
    private var showItemsListSegue: String = "showItemsList"
    private var showUploadCoverSegue: String = "showUploadCover"
    private var showSoundListSegue: String = "showSoundList"
    private var showStoryTextSegue: String = "showStoryText"
    private var showVoiceOverSegue: String = "showVoiceOver"
    private var showCreateStorySegue: String = "showCreateStory"
    
    private var listType: CSListType?
    
    @IBOutlet weak var languageItem: ItemViewWithSubtitleAndCheckmark!
    @IBOutlet weak var topicItem: ItemViewWithSubtitleAndCheckmark!
    @IBOutlet weak var categoryItem: ItemViewWithSubtitleAndCheckmark!
    @IBOutlet weak var subCategoryitem: ItemViewWithSubtitleAndCheckmark!
    @IBOutlet weak var languageLevelItem: ItemViewWithSubtitleAndCheckmark!
    @IBOutlet weak var coverItem: ItemViewWithSubtitleAndCheckmark!
    @IBOutlet weak var storyTextItem: ItemViewWithSubtitleAndCheckmark!
    @IBOutlet weak var storyVoiceOverItem: ItemViewWithSubtitleAndCheckmark!
    @IBOutlet weak var createStoryButton: RegularButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLanguage()
        setUpActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkItems()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVc = segue.destination as? CSItemsListViewController {
            nextVc.listType = listType
        }
    }
    
    @IBAction func createStoryButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: showCreateStorySegue, sender: nil)
    }
    
    private func setUpLanguage() {
        languageItem.setUp(title: "cs_main_list_language_title".localized,
                           subtitle: "cs_main_list_language_subtitle".localized)
        topicItem.setUp(title: "cs_main_list_topic_title".localized,
                           subtitle: "cs_main_list_topic_subtitle".localized)
        categoryItem.setUp(title: "cs_main_list_category_title".localized,
                              subtitle: "cs_main_list_category_subtitle".localized)
        subCategoryitem.setUp(title: "cs_main_list_sub_category_title".localized,
                              subtitle: "cs_main_list_sub_category_subtitle".localized)
        languageLevelItem.setUp(title: "cs_main_list_language_level_title".localized,
                                subtitle: "cs_main_list_language_level_subtitle".localized)
        coverItem.setUp(title: "cs_main_list_cover_title".localized,
                        subtitle: "cs_main_list_cover_subtitle".localized)
        storyTextItem.setUp(title: "cs_main_list_story_text_title".localized,
                            subtitle: "cs_main_list_story_text_subtitle".localized)
        storyVoiceOverItem.setUp(title: "cs_main_list_voice_over_title".localized,
                                 subtitle: "cs_main_list_voice_over_subtitle".localized)
        createStoryButton.setTitle("cs_main_list_create_story_button".localized,
                                   for: .normal)
        createStoryButton.setTitle("cs_main_list_create_story_button".localized,
                                   for: .disabled)
    }
    
    private func setUpActions() {
        languageItem.onClick = {
            self.listType = .language
            self.performSegue(withIdentifier: self.showItemsListSegue, sender: nil)
        }
        topicItem.onClick = {
            self.listType = .topic
            self.performSegue(withIdentifier: self.showItemsListSegue, sender: nil)
        }
        categoryItem.onClick = {
            self.listType = .category
            self.performSegue(withIdentifier: self.showItemsListSegue, sender: nil)
        }
        subCategoryitem.onClick = {
            self.listType = .subCategory
            self.performSegue(withIdentifier: self.showItemsListSegue, sender: nil)
        }
        languageLevelItem.onClick = {
            self.listType = .languageLevel
            self.performSegue(withIdentifier: self.showItemsListSegue, sender: nil)
        }
        coverItem.onClick = {
            self.performSegue(withIdentifier: self.showUploadCoverSegue, sender: nil)
        }
        storyTextItem.onClick = {
            self.performSegue(withIdentifier: self.showStoryTextSegue, sender: nil)
        }
        storyVoiceOverItem.onClick = {
            self.performSegue(withIdentifier: self.showVoiceOverSegue, sender: nil)
        }
    }
    
    private func loadItems() {
        topicItem.isChecked = CreateStoryObject.shared?.topic != nil
        if topicItem.isChecked {
            topicItem.subtitle = CreateStoryObject.shared?.topic?.name
        } else {
            topicItem.subtitle = "cs_main_list_topic_subtitle".localized
        }
        categoryItem.isChecked = CreateStoryObject.shared?.category != nil
        if categoryItem.isChecked {
            categoryItem.subtitle = CreateStoryObject.shared?.category?.name
        } else {
            categoryItem.subtitle = "cs_main_list_category_subtitle".localized
        }
        subCategoryitem.isChecked = CreateStoryObject.shared?.subCategory != nil
        if subCategoryitem.isChecked {
            subCategoryitem.subtitle = CreateStoryObject.shared?.subCategory?.name
        } else {
            subCategoryitem.subtitle = "cs_main_list_sub_category_subtitle".localized
        }
        languageItem.isChecked = CreateStoryObject.shared?.language != nil
        if languageItem.isChecked {
            languageItem.subtitle = CreateStoryObject.shared?.language?.name
        } else {
            languageItem.subtitle = "cs_main_list_language_subtitle".localized
        }
        languageLevelItem.isChecked = CreateStoryObject.shared?.chapter?.languageLevel != nil
        if languageLevelItem.isChecked {
            languageLevelItem.subtitle = CreateStoryObject.shared?.chapter?.languageLevel?.name
        } else {
            languageLevelItem.subtitle = "cs_main_list_language_level_subtitle".localized
        }
        coverItem.isChecked = CreateStoryObject.shared?.chapter?.cover != nil
        if coverItem.isChecked {
            coverItem.subtitle = CreateStoryObject.shared?.topic?.name
        } else {
            coverItem.subtitle = "cs_main_list_cover_subtitle".localized
        }
        storyTextItem.isChecked = !(CreateStoryObject.shared?.chapterStoryParts?.isEmpty ?? true)
        storyVoiceOverItem.isChecked = CreateStoryObject.shared?.chapter?.voiceOver != nil
    }
    
    private func checkItems() {
        loadItems()
        topicItem.isEnabled = languageItem.isChecked
        categoryItem.isEnabled = topicItem.isChecked
        subCategoryitem.isEnabled = categoryItem.isChecked
        languageLevelItem.isEnabled = subCategoryitem.isChecked
        coverItem.isEnabled = languageLevelItem.isChecked
        storyTextItem.isEnabled = languageLevelItem.isChecked
        storyVoiceOverItem.isEnabled = languageLevelItem.isChecked
        if !languageItem.isChecked {
            createStoryButton.isEnabled = false
            return
        }
        if !topicItem.isChecked {
            createStoryButton.isEnabled = false
            return
        }
        if !categoryItem.isChecked {
            createStoryButton.isEnabled = false
            return
        }
        if !subCategoryitem.isChecked {
            createStoryButton.isEnabled = false
            return
        }
        if !languageLevelItem.isChecked {
            createStoryButton.isEnabled = false
            return
        }
        if !coverItem.isChecked {
            createStoryButton.isEnabled = false
            return
        }
        if !storyTextItem.isChecked {
            createStoryButton.isEnabled = false
            return
        }
        if !storyVoiceOverItem.isChecked {
            createStoryButton.isEnabled = false
            return
        }
        createStoryButton.isEnabled = true
    }
}
