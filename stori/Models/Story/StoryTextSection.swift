//
//  StoryTextSection.swift
//  stori
//
//  Created by Alex on 01.03.2021.
//

import Foundation
import PromiseKit

class StoryTextSection: StorySection {
    var text: String
    var words: [CSWord]
    var isEditMode: Bool
    
    init(text: String,
         chapterId: Int) {
        self.text = text
        words = []
        isEditMode = true
        super.init(type: .text)
        finishedUpload = true
        updateWords()
        createSection(chapterId: chapterId)
    }
    
    init(id: Int,
         text: String,
         words: [Word]) {
        self.text = text
        self.words = []
        for word in words {
            self.words.append(CSWord(word: word))
        }
        isEditMode = false
        super.init(id: id, type: .text)
    }
    
    func updateWords() {
        words = []
        for item in text.components(separatedBy: [" "]) {
            words.append(CSWord(word: item))
        }
    }
    
    func canSelect(wordIndex: Int, selectedWords: [Int]) -> Bool {
        if selectedWords.isEmpty { return true }
        for item in selectedWords {
            if wordIndex == item - 1 || wordIndex == item + 1 {
                return true
            }
        }
        return false
    }
    
    func selectedExpression(selectedWords: [Int]) -> String {
        let orderedWords = selectedWords.sorted()
        var selectedWords: [CSWord] = []
        for wordIndex in orderedWords {
            selectedWords.append(words[wordIndex])
        }
        return selectedWords.map({ $0.word }).joined(separator: " ")
    }
    
    func merge(selectedWords: [Int]) -> Bool {
        // Checking that expression contains 2 or more words
        if selectedWords.count < 2 { return false }
        
        // Sorting words in order
        let orderedWords = selectedWords.sorted()
        
        // Checking if words are consecutive
        let consecutives = orderedWords.map { $0 - 1 }.dropFirst() == orderedWords.dropLast()
        if !consecutives { return false }
        
        // Creating the new expression
        var selectedWords: [CSWord] = []
        for wordIndex in orderedWords {
            selectedWords.append(words[wordIndex])
        }
        let newItem = CSWord(word: selectedWords.map({ $0.word }).joined(separator: " "))
        
        // Removing words from list
        let reversedWords = orderedWords.reversed()
        for item in reversedWords {
            words.remove(at: item)
        }
        
        // Inserting the new expression in list
        guard let firstPlace = orderedWords.first else { return false }
        words.insert(newItem, at: firstPlace)
        
        // Success
        return true
    }
    
    func unmerge(wordIndex: Int) -> Bool {
        // Check if word is expression, if not return
        if !words[wordIndex].isExpression { return false }
        
        // Create the list with new words
        let expressionWords = words[wordIndex].word.split(separator: " ")
        let reversedExpressionWords = expressionWords.reversed()
        
        // Remove word at given place
        words.remove(at: wordIndex)
        
        // Insert words into current array of words
        for item in reversedExpressionWords {
            let csWord = CSWord(word: String(item))
            words.insert(csWord, at: wordIndex)
        }
        
        // Success
        return true
    }
    
    func removeWord(wordIndex: Int) -> Bool {
        if wordIndex >= words.count { return false }
        words.remove(at: wordIndex)
        text = words.map({ $0.word }).joined(separator: " ")
        return true
    }
    
    func createSection(chapterId: Int) {
        CSPresenter.chapterPart.createChapterPart(chapterId: chapterId, part: self)
            .done { (section) in
                guard let textSection = section as? StoryTextSection else { return }
                self.id = textSection.id
                self.words = textSection.words
                self.text = textSection.text
            }
            .cauterize()
    }
    
    func updateSection(completion: @escaping () -> Void) {
        CSPresenter.chapterPart.updateChapterPart(part: self)
            .done { (section) in
                guard let textSection = section as? StoryTextSection else { return }
                self.id = textSection.id
                self.words = textSection.words
                self.text = textSection.text
                CSPresenter.chapterPart.checkWords(words: textSection.words)
                    .done { (newWords) in
                        if !newWords.isEmpty {
                            self.words = newWords
                            self.finishedUpload = newWords.allSatisfy({ $0.isApproved })
                        }
                        completion()
                    }
                    .cauterize()
            }
            .cauterize()
    }
}

class CSWord {
    var word: String
    var isExpression: Bool {
        return word.split(separator: " ").count >= 2
    }
    var isApproved: Bool
    var level: String?
    
    init(word: String) {
        self.word = word
        self.isApproved = true
    }
    
    init(word: Word) {
        self.word = word.word
        isApproved = true
    }
}
