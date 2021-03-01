//
//  CSTextItemTableViewCell.swift
//  stori
//
//  Created by Alex on 01.02.2021.
//

import UIKit
import TagListView
import PopMenu

class CSTextItemTableViewCell: CSTableViewCell {

    var updateView: (() -> Void)?
    
    var section: StoryTextSection?
    private var selectedTags: [Int] = []
    
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var storyTextView: UITextView!
    @IBOutlet weak var charCountLabel: UILabel!
    
    @IBOutlet weak var wordsView: UIView!
    @IBOutlet weak var tagListView: TagListView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        storyTextView.delegate = self
        tagListView.textFont = .IBMPlexSans(size: 13)
        tagListView.delegate = self
        if let section = section {
            setUp(section: section)
        }
        charCountLabel.text = "\((storyTextView.text ?? "").count)/255"
        actionButton.isEnabled = !(storyTextView.text ?? "").isEmpty
    }
    
    override func prepareForReuse() {
        if let section = section {
            setUp(section: section)
        }
    }
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        if editView.isHidden {
            showEditText()
        } else {
            showTagList()
        }
    }
    
    func reloadWords() {
        guard let section = section else { return }
        selectedTags = []
        tagListView.removeAllTags()
        for item in section.words {
            if item.isApproved {
                self.tagListView.addTag(item.word)
            } else {
                let tagView = self.tagListView.addTag(item.word)
                tagView.tagBackgroundColor = .removeRed
            }
        }
        updateView?()
        layoutIfNeeded()
    }
    
    func updateWords() {
        guard let section = section else { return }
        section.updateSection {
            self.reloadWords()
        }
    }
    
    private func showEditText() {
        guard editView.isHidden else {
            layoutIfNeeded()
            return
        }
        tagListView.removeAllTags()
        UIView.transition(from: wordsView,
                          to: editView,
                          duration: 0.4,
                          options: [.transitionCrossDissolve,
                                    .layoutSubviews,
                                    .showHideTransitionViews]) { _ in
            self.storyTextView.becomeFirstResponder()
            self.updateView?()
        }
        actionButton.setImage(UIImage(named: "check_mark_clear"), for: .normal)
        section?.isEditMode = true
        layoutIfNeeded()
    }
    
    private func showTagList(shouldSplitWords: Bool = true) {
        guard wordsView.isHidden else {
            reloadWords()
            return
        }
        storyTextView.resignFirstResponder()
        UIView.transition(from: editView,
                          to: wordsView,
                          duration: 0.4,
                          options: [.transitionCrossDissolve,
                                    .layoutSubviews,
                                    .showHideTransitionViews],
                          completion: nil)
        actionButton.setImage(UIImage(named: "edit"), for: .normal)
        section?.isEditMode = false
        section?.text = storyTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if shouldSplitWords {
            section?.updateWords()
        }
        reloadWords()
        updateWords()
    }
    
    func setUp(section: StoryTextSection) {
        self.section = section
        storyTextView.text = section.text
        if section.isEditMode {
            showEditText()
        } else {
            showTagList(shouldSplitWords: false)
        }
    }
}

extension CSTextItemTableViewCell: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        updateView?()
        actionButton.isEnabled = !(storyTextView.text ?? "").isEmpty
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text.rangeOfCharacter(from: CharacterSet.newlines) == nil else {
            showTagList()
            return false
        }
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        charCountLabel.textColor = updatedText.count >= 255 ? .red : .lightGray
        charCountLabel.text = "\(updatedText.count >= 255 ? 255 : updatedText.count)/255"
        return updatedText.count <= 255
    }
}

extension CSTextItemTableViewCell: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        guard let selectedIndex = sender.tagViews.firstIndex(of: tagView) else { return }
        if !(section?.words[selectedIndex].isApproved ?? true) {
            let menuViewController = PopMenuViewController(sourceView: tagView, actions: [
                PopMenuActionBuilder.titleAction(title: section?.words[selectedIndex].word ?? ""),
                PopMenuActionBuilder.removeWord(level: section?.words[selectedIndex].level ?? "", action: {
                    if self.section?.removeWord(wordIndex: selectedIndex) ?? false {
                        self.reloadWords()
                        self.updateWords()
                    }
                })
            ])
            menuViewController.appearance.popMenuColor.backgroundColor = .solid(fill: .background)
            menuViewController.appearance.popMenuColor.actionColor = .tint(Color(cgColor: UIColor.textGray.cgColor))
            UIApplication.getTopViewController()?.present(menuViewController, animated: true, completion: nil)
        } else if (section?.canSelect(wordIndex: selectedIndex, selectedWords: selectedTags)) ?? false,
                  !tagView.isSelected {
            selectedTags.append(selectedIndex)
            tagView.isSelected = true
            let selectedExpression = section?.selectedExpression(selectedWords: selectedTags) ?? ""
            if section?.words[selectedIndex].isExpression ?? false {
                let menuViewController = PopMenuViewController(sourceView: tagView, actions: [
                    PopMenuActionBuilder.titleAction(title: selectedExpression),
                    PopMenuActionBuilder.unmergeAction {
                        if self.section?.unmerge(wordIndex: selectedIndex) ?? false {
                            self.reloadWords()
                            self.updateWords()
                        }
                    }
                ])
                menuViewController.appearance.popMenuColor.backgroundColor = .solid(fill: .background)
                menuViewController.appearance.popMenuColor.actionColor = .tint(Color(cgColor: UIColor.textGray.cgColor))
                UIApplication.getTopViewController()?.present(menuViewController, animated: true, completion: nil)
            } else if selectedTags.count >= 2 {
                let menuViewController = PopMenuViewController(sourceView: tagView, actions: [
                    PopMenuActionBuilder.titleAction(title: selectedExpression),
                    PopMenuActionBuilder.mergeAction {
                        if self.section?.merge(selectedWords: self.selectedTags) ?? false {
                            self.reloadWords()
                            self.updateWords()
                        }
                    }
                ])
                menuViewController.appearance.popMenuColor.backgroundColor = .solid(fill: .background)
                menuViewController.appearance.popMenuColor.actionColor = .tint(Color(cgColor: UIColor.textGray.cgColor))
                UIApplication.getTopViewController()?.present(menuViewController, animated: true, completion: nil)
            }
        } else {
            selectedTags.removeAll(where: { $0 == selectedIndex })
            tagView.isSelected = false
        }
    }
}

struct PopMenuActionBuilder {
    static func titleAction(title: String) -> PopMenuDefaultAction {
        return PopMenuDefaultAction(title: title)
    }
    
    static func mergeAction(action: @escaping () -> Void) -> PopMenuDefaultAction {
        return PopMenuDefaultAction(title: "cs_text_merge".localized,
                                    image: UIImage(named: "merge"),
                                    color: .textBlack) { (_) in
            action()
        }
    }
    
    static func unmergeAction(action: @escaping () -> Void) -> PopMenuDefaultAction {
        return PopMenuDefaultAction(title: "cs_text_unmerge".localized,
                                    image: UIImage(named: "unmerge"),
                                    color: .textBlack) { (_) in
            action()
        }
    }
    
    static func removeWord(level: String,
                           action: @escaping () -> Void) -> PopMenuDefaultAction {
        return PopMenuDefaultAction(title: String(format: "cs_text_remove_word".localized, level),
                                    image: UIImage(named: "clear_circle"),
                                    color: .removeRed) { (_) in
            action()
        }
    }
}
