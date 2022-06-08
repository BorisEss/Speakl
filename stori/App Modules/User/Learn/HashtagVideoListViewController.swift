//
//  HashtagVideoListViewController.swift
//  stori
//
//  Created by Alex on 21.12.2021.
//

import UIKit

class HashtagVideoListViewController: UIViewController {
    
    var videos: [Video] = []
    
    var hashtag: Hashtag?

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var followButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let hashtag = hashtag else {
            return
        }

        titleLabel.text = hashtag.name
        loadJson()
        followButton.backgroundColor = .speaklAccentColor
    }
    
    private func loadJson() {
        if let url = Bundle.main.url(forResource: "video", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(JsonVideo.self, from: data)
                videos = jsonData.videos
            } catch {
                videos = []
                print("error:\(error)")
            }
        } else {
            videos = []
        }
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func followButtonPressed(_ sender: UIButton) {
        if sender.backgroundColor == .speaklAccentColor {
            sender.backgroundColor = .speaklWhite
            sender.setTitleColor(.speaklGradientTop, for: .normal)
            sender.setTitle("Following", for: .normal)
        } else {
            sender.backgroundColor = .speaklAccentColor
            sender.setTitleColor(.speaklWhite, for: .normal)
            sender.setTitle("Follow", for: .normal)
        }
    }
}

extension HashtagVideoListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HastagVideoCollectionViewCell",
                                                          for: indexPath)
        if let cell = mainCell as? HastagVideoCollectionViewCell {
            cell.setUp(video: videos[indexPath.item])
            return cell
        }
        return mainCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Learn", bundle: nil)
        let nextScreen = storyBoard.instantiateViewController(withIdentifier: "MainStoryVideoListViewController")
        if let unwrappedNextScreen = nextScreen as? MainStoryVideoListViewController {
            unwrappedNextScreen.position = indexPath.item
//            if searchBar.text?.isEmpty ?? true {
//                unwrappedNextScreen.hashtag = trendingHashtags[indexPath.row]
//            } else {
//                unwrappedNextScreen.hashtag = searchedHashtags[indexPath.row]
//            }
            navigationController?.pushViewController(unwrappedNextScreen, animated: true)
        }
    }
}

extension HashtagVideoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width - 4) / 3
        let cellHeight = cellWidth * 16 / 9
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
