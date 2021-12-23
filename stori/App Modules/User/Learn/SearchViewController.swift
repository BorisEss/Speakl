//
//  SearchViewController.swift
//  stori
//
//  Created by Alex on 04.12.2021.
//

import UIKit
import FBSDKCoreKit

enum SearchType {
    case author
    case hashtag
}

struct Author {
    var name: String
    var image: UIImage?
    var students: Int
}

struct Hashtag {
    var name: String
    var popularity: Int
}

class SearchViewController: UIViewController {
    
    private var recentAuthors: [Author] = [
        Author(name: "John Doe", image: UIImage(named: "test_user"), students: 20),
        Author(name: "Will Dickson", image: UIImage(named: "test_user"), students: 100),
        Author(name: "Andrew Doe", image: UIImage(named: "test_user"), students: 1334),
        Author(name: "James Thomas", image: UIImage(named: "test_user"), students: 1),
        Author(name: "Tom Red", image: UIImage(named: "test_user"), students: 432),
        Author(name: "Mathew Peterson", image: UIImage(named: "test_user"), students: 543215),
        Author(name: "Peter Parker", image: UIImage(named: "test_user"), students: 2230)
    ]
    private var popularAuthors: [Author] = [
        Author(name: "John Doe", image: UIImage(named: "test_user"), students: 20),
        Author(name: "Will Dickson", image: UIImage(named: "test_user"), students: 100),
        Author(name: "Andrew Doe", image: UIImage(named: "test_user"), students: 1334)
    ]
    private var searchedAuthors: [Author] = []
    
    private var trendingHashtags: [Hashtag] = [
        Hashtag(name: "#trend", popularity: 234231),
        Hashtag(name: "#popular", popularity: 2344),
        Hashtag(name: "#winter", popularity: 23451),
        Hashtag(name: "#life", popularity: 5432),
        Hashtag(name: "#like", popularity: 2345),
        Hashtag(name: "#learn", popularity: 1235),
        Hashtag(name: "#english", popularity: 154),
        Hashtag(name: "#party", popularity: 345),
        Hashtag(name: "#grade", popularity: 34)
    ]
    private var searchedHashtags: [Hashtag] = []
    
    var searchType: SearchType = .author {
        didSet {
            switch searchType {
            case .author:
                authorsButton.isChecked = true
                hashtagsButton.isChecked = false
                // TODO: Reload author search
            case .hashtag:
                authorsButton.isChecked = false
                hashtagsButton.isChecked = true
                // TODO: Reload hashtag search
            }
        }
    }

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var authorsButton: UnderlinedButton!
    @IBOutlet weak var hashtagsButton: UnderlinedButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noResultsView: UIStackView!
    // TODO: Update No Results's localized texts
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: Update localized text
        title = "Search"
        searchBar.placeholder = "Search"
        searchBar.becomeFirstResponder()
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    @IBAction func authorsPressed(_ sender: Any) {
        searchType = .author
        tableView.reloadData()
    }
    @IBAction func hashtagsPressed(_ sender: Any) {
        searchType = .hashtag
        tableView.reloadData()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        switch searchType {
        case .author:
            if searchText.isEmpty {
                searchedAuthors = []
            } else {
                searchedAuthors = recentAuthors.filter({ $0.name.contains(searchText) })
            }
        case .hashtag:
            if searchText.isEmpty {
                searchedHashtags = []
            } else {
                searchedHashtags = trendingHashtags.filter({ $0.name.contains(searchText) })
            }
        }
        tableView.reloadData()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noResultsView.isHidden = true
        switch searchType {
        case .author:
            if searchBar.text?.isEmpty ?? true {
                if recentAuthors.isEmpty {
                    return popularAuthors.count
                } else {
                    return recentAuthors.count
                }
            } else {
                noResultsView.isHidden = !searchedAuthors.isEmpty
                return searchedAuthors.count
            }
        case .hashtag:
            if searchBar.text?.isEmpty ?? true {
                return trendingHashtags.count
            } else {
                noResultsView.isHidden = !searchedHashtags.isEmpty
                return searchedHashtags.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch searchType {
        case .author:
            let mainCell = tableView.dequeueReusableCell(withIdentifier: "SearchUserTableViewCell", for: indexPath)
            if let cell = mainCell as? SearchUserTableViewCell {
                if searchBar.text?.isEmpty ?? true {
                    if !recentAuthors.isEmpty {
                        cell.setUp(image: recentAuthors[indexPath.row].image,
                                   name: recentAuthors[indexPath.row].name,
                                   studentsCount: recentAuthors[indexPath.row].students)
                    } else {
                        cell.setUp(image: popularAuthors[indexPath.row].image,
                                   name: popularAuthors[indexPath.row].name,
                                   studentsCount: popularAuthors[indexPath.row].students)
                    }
                } else {
                    cell.setUp(image: searchedAuthors[indexPath.row].image,
                               name: searchedAuthors[indexPath.row].name,
                               studentsCount: searchedAuthors[indexPath.row].students)
                }
                return cell
            }
            return mainCell
        case .hashtag:
            let mainCell = tableView.dequeueReusableCell(withIdentifier: "SearchHashtagTableViewCell", for: indexPath)
            if let cell = mainCell as? SearchHashtagTableViewCell {
                if searchBar.text?.isEmpty ?? true {
                    cell.setUp(hashtag: trendingHashtags[indexPath.row].name,
                               count: trendingHashtags[indexPath.row].popularity)
                } else {
                    cell.setUp(hashtag: searchedHashtags[indexPath.row].name,
                               count: searchedHashtags[indexPath.row].popularity)
                }
                return cell
            }
            return mainCell
        }
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let mainHeader = tableView.dequeueReusableCell(withIdentifier: "SearchHeaderTableViewCell")
        if let header = mainHeader as? SearchHeaderTableViewCell {
            switch searchType {
            case .author:
                // TODO: Update localized text
                if searchBar.text?.isEmpty ?? true {
                    if !recentAuthors.isEmpty {
                        header.setTitle(title: "Recent searches")
                    } else {
                        header.setTitle(title: "Most popular")
                    }
                } else {
                    header.setTitle(title: "Search results")
                }
            case .hashtag:
                if searchBar.text?.isEmpty ?? true {
                    header.setTitle(title: "Trending hashtags")
                } else {
                    header.setTitle(title: "Search results")
                }
            }
            return header
        }
        return mainHeader
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchType == .author,
           searchBar.text?.isEmpty ?? true,
           !recentAuthors.isEmpty {
            return true
        }
        return false
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if searchType == .author,
               !recentAuthors.isEmpty {
                recentAuthors.remove(at: indexPath.row)
                if recentAuthors.isEmpty {
                    tableView.reloadData()
                } else {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch searchType {
        case .author:
            // TODO: Open Author
            if searchBar.text?.isEmpty ?? true {
                if recentAuthors.isEmpty {
                    Toast.success(popularAuthors[indexPath.row].name)
                } else {
                    Toast.success(recentAuthors[indexPath.row].name)
                }
            } else {
                Toast.success(searchedAuthors[indexPath.row].name)
            }
        case .hashtag:
            // TODO: Open Hashtag
            let storyBoard: UIStoryboard = UIStoryboard(name: "Learn", bundle: nil)
            let nextScreen = storyBoard.instantiateViewController(withIdentifier: "HashtagVideoListViewController")
            if let unwrappedNextScreen = nextScreen as? HashtagVideoListViewController {
                if searchBar.text?.isEmpty ?? true {
                    unwrappedNextScreen.hashtag = trendingHashtags[indexPath.row]
                } else {
                    unwrappedNextScreen.hashtag = searchedHashtags[indexPath.row]
                }
                navigationController?.pushViewController(unwrappedNextScreen, animated: true)
            }
        }
    }
}
