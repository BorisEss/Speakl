//
//  ReviewViewController.swift
//  stori
//
//  Created by Alex on 18.04.2022.
//

import UIKit

class ReviewViewController: UIViewController {
    
    // MARK: - Parameters
    var selectedTopic: Topic? {
        didSet {
            if let selectedTopic = selectedTopic {
                titleLabel.text = selectedTopic.name
            }
        }
    }
    var words: [VocabularyWord] = [
        VocabularyWord(id: 0, word: "airplane",
                       definition: "A powered heavier-than-air aircraft with fixed wings.",
                       url: "https://upload.wikimedia.org/wikipedia/commons/c/cb/Ryanair.arp.750pix.jpg"),
        VocabularyWord(id: 1, word: "dog",
                       definition: "A common animal with four legs, especially kept by people as a pet or to hunt or guard things.",
                       url: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg"),
        VocabularyWord(id: 2, word: "deer",
                       definition: "A quite large animal with four legs that eats grass and leaves.",
                       url: "https://i.natgeofe.com/n/9c0acdf6-2d60-4149-9f84-b95244f200a8/Minden_00962361_square.jpg"),
        VocabularyWord(id: 3, word: "butterfly",
                       definition: "A type of insect with large, often brightly coloured wings.",
                       url: "http://images6.fanpop.com/image/photos/43400000/Butterfly-jessoweys-special-icons-made-by-my-friends-43498829-1230-692.jpg"),
        VocabularyWord(id: 4, word: "prison",
                       definition: "A building where criminals are forced to live as a punishment.",
                       url: "https://media.npr.org/assets/img/2013/01/18/prison-d7f96423c0e1ee1b55c455b9266cf9d28a3d17a5.jpg"),
        VocabularyWord(id: 5, word: "peace",
                       definition: "Freedom from war and violence, especially when people live and work together happily without disagreements.",
                       url: "https://ethicalleaderdotblog.files.wordpress.com/2020/05/peace-2.jpg"),
        VocabularyWord(id: 6, word: "zebra",
                       definition: "An African wild animal that looks like a horse, with black or brown and white lines on its body.",
                       url: "https://cdn.mos.cms.futurecdn.net/HjFE8NKWuCmgfHCcndJ3rK.jpg"),
        VocabularyWord(id: 7, word: "gold",
                       definition: "A chemical element that is a valuable, shiny, yellow metal used to make coins and jewellery.",
                       url: "https://responsive.fxempire.com/cover/615x410/_n/_fxempire_/2022/02/Gold-Bars.jpg"),
        VocabularyWord(id: 8, word: "fish",
                       definition: "A limbless cold-blooded vertebrate animal with gills and fins living wholly in water.",
                       url: "https://thepleasantdream.com/wp-content/uploads/2021/03/Fish-Dream-Meaning-%E2%80%93-50-Types-and-Interpretation-2.jpg"),
        VocabularyWord(id: 9, word: "ear",
                       definition: "the organ of hearing and balance of vertebrates.",
                       url: "https://cdn.mos.cms.futurecdn.net/NvekX9tT7peSEUHRersaT8.jpg"),
        VocabularyWord(id: 10, word: "foot",
                       definition: "The lower extremity of the leg below the ankle, on which a person stands or walks.",
                       url: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2021/12/feet-plantar-fasciitis-gout-thumb-732x549.jpg"),
        VocabularyWord(id: 11, word: "swim",
                       definition: "Propel the body through water by using the limbs.",
                       url: "https://d1s9j44aio5gjs.cloudfront.net/2016/07/The_Benefits_of_Swimming.jpg"),
        VocabularyWord(id: 12, word: "walk",
                       definition: "Move at a regular pace by lifting and setting down each foot in turn, never having both feet off the ground at once.",
                       url: "https://www.gannett-cdn.com/presto/2021/08/02/USAT/7cf3aab6-3094-46ce-aff0-c37a2108f98b-walking1.jpg"),
        VocabularyWord(id: 13, word: "taste",
                       definition: "The sensation of flavour perceived in the mouth and throat on contact with a substance.",
                       url: "https://as2.ftcdn.net/v2/jpg/02/69/78/15/1000_F_269781575_uuyUPccMXx2SjZgONL18Jl8rG5C0tWre.jpg"),
        VocabularyWord(id: 14, word: "train",
                       definition: "A series of connected railway carriages or wagons moved by a locomotive or by integral motors.",
                       url: "https://cdn.londonandpartners.com/visit/london-organisations/transport-system/59590-640x360-overground-train_640.jpg"),
        VocabularyWord(id: 15, word: "train",
                       definition: "Teach (a person or animal) a particular skill or type of behaviour through practice and instruction over a period of time.",
                       url: "https://www.akc.org/wp-content/uploads/2018/08/bernese-mountain-dog-looking-up-at-finger-command.jpg")
    ]
    
    var groupedWords: [(letter: String, words: [VocabularyWord])] = []
    
    // MARK: - IBOutlets
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchNoDataView: UIStackView!
    @IBOutlet weak var searchNoDataTitleLabel: UILabel!
    @IBOutlet weak var searchNoDataDescriptionLabel: UILabel!
    @IBOutlet weak var activityIndicator: AppActivityIndicator!
    
    @IBOutlet weak var noDataView: UIStackView!
    @IBOutlet weak var noDataTitleLabel: UILabel!
    @IBOutlet weak var noDataDescriptionLabel: UILabel!
    @IBOutlet weak var noDataLearnButton: UIButton!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        languageButton.load(url: Storage.shared.currentUser?.learningLanguage?.flagUrl)
        
        groupedWords = groupWords(words: words)
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
       }
        tableView.register(ReviewHeaderTableViewCell.nib(),
                           forCellReuseIdentifier: ReviewHeaderTableViewCell.identifier)
        tableView.register(ReviewTopicsTableViewCell.nib(),
                           forCellReuseIdentifier: ReviewTopicsTableViewCell.identifier)
        tableView.register(ReviewWordTableViewCell.nib(),
                           forCellReuseIdentifier: ReviewWordTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (tabBarController as? MainTabBarViewController)?.setNonTransparent()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let nextVc = segue.destination as? ReviewTrainingLevelViewController {
            nextVc.wordCount = words.count
        }
        if let nextVc = segue.destination as? ReviewTrainingLevelViewController {
            nextVc.completion = { level in
                let storyBoard: UIStoryboard = UIStoryboard(name: "Review", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "ReviewTrainingViewController")
                guard let controller = newViewController as? ReviewTrainingViewController  else { return }
                controller.words = self.words
                controller.level = level
                controller.modalPresentationStyle = .overFullScreen
                self.present(controller, animated: true)
            }
        }
    }
    
    // MARK: - Button Actions
    @IBAction func languageButtonPressed(_ sender: Any) {
        // TODO: If needed then disable this button on click action
//        if (Storage.shared.currentUser?.learningLanguages.count ?? 1) != 1 {
            performSegue(withIdentifier: "showLanguagePopup", sender: nil)
//        }
    }
    
    @IBAction func reviewButtonPressed(_ sender: Any) {
        if words.count < 10 {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Review", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "ReviewTrainingViewController")
            guard let controller = newViewController as? ReviewTrainingViewController  else { return }
            controller.words = words
            controller.level = .fullVocabulary
            controller.modalPresentationStyle = .overFullScreen
            self.present(controller, animated: true)
        } else {
            performSegue(withIdentifier: "showLevelPopup", sender: nil)
        }
    }
    
    @IBAction func noDataLearnButtonPressed(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
    
    // MARK: - Methods
    func groupWords(words: [VocabularyWord]) -> [(letter: String, words: [VocabularyWord])] {
        let filteredWords = words.sorted(by: { $0.word < $1.word })
        var newGrouppedWords: [(letter: String, words: [VocabularyWord])] = []
        for word in filteredWords {
            guard let letter = word.word.first?.uppercased() else { return [] }
            if newGrouppedWords.contains(where: {$0.letter == letter}) {
                if let index = newGrouppedWords.firstIndex(where: {$0.letter == letter}) {
                    newGrouppedWords[index].words.append(word)
                }
            } else {
                newGrouppedWords.append((letter: letter, words: [word]))
            }
        }
        return newGrouppedWords
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let mainCell = tableView.dequeueReusableCell(withIdentifier: ReviewHeaderTableViewCell.identifier)
        if let cell = mainCell as? ReviewHeaderTableViewCell {
            if section == 0 {
                cell.backgroundColor = .speaklWhite
                cell.setUp(name: "Topics", shouldShowClose: selectedTopic != nil)
                cell.delegate = self
            } else {
                cell.backgroundColor = .clear
                cell.setUp(name: groupedWords[section - 1].letter)
                cell.layer.shouldRasterize = true
                cell.layer.rasterizationScale = UIScreen.main.scale
            }
            return cell
        }
        return mainCell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        searchNoDataView.isHidden = !groupedWords.isEmpty
        if !(searchBar.text?.isEmpty ?? true), groupedWords.isEmpty, selectedTopic == nil { return 0 }
        return groupedWords.count + 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return groupedWords[section - 1].words.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let mainCell = tableView.dequeueReusableCell(withIdentifier: ReviewTopicsTableViewCell.identifier,
                                                         for: indexPath)
            if let cell = mainCell as? ReviewTopicsTableViewCell {
                cell.delegate = self
                cell.setTopic(topic: selectedTopic)
                return cell
            }
            return mainCell
        default:
            let mainCell = tableView.dequeueReusableCell(withIdentifier: ReviewWordTableViewCell.identifier,
                                                         for: indexPath)
            if let cell = mainCell as? ReviewWordTableViewCell {
                cell.setUp(word: groupedWords[indexPath.section - 1].words[indexPath.row])
                return cell
            }
            return mainCell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if selectedTopic != nil,
            section == 0 {
            titleLabel.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if selectedTopic != nil,
           section == 0 {
            titleLabel.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section != 0 else { return }
        let storyBoard: UIStoryboard = UIStoryboard(name: "WordExplanation", bundle: nil)
        let nextScreen = storyBoard.instantiateViewController(withIdentifier: "SelectedWordViewController")
        if let unwrappedNextScreen = nextScreen as? SelectedWordViewController {
//            unwrappedNextScreen.hashtag = Hashtag(name: hashtag, popularity: 0)
            
            self.navigationController?.pushViewController(unwrappedNextScreen, animated: true)
        }
    }
}

// MARK: - UISearchBarDelegate
extension ReviewViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            groupedWords = groupWords(words: words)
        } else {
            let newWords = words.filter({$0.word.uppercased().contains(searchText.uppercased())})
            groupedWords = groupWords(words: newWords)
        }
        tableView.reloadData()
    }
}

extension ReviewViewController: ReviewHeaderTableViewCellDelegate {
    func clearButtonWasPressed() {
        selectedTopic = nil
        tableView.reloadData()
    }
}

extension ReviewViewController: ReviewTopicsTableViewCellDelegate {
    func didSelectTopic(topic: Topic) {
        selectedTopic = topic
        tableView.reloadData()
    }
}
