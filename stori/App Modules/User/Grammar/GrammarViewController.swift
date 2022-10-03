//
//  GrammarViewController.swift
//  stori
//
//  Created by Alex on 20.07.2022.
//

import UIKit

class GrammarViewController: UIViewController {

    var categories: [GrammarCategory] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var progressActivityIndicator: AppActivityIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressActivityIndicator.startAnimating()
        GrammarService().getCategories()
            .ensure {
                self.progressActivityIndicator.stopAnimating()
            }
            .done { categories in
                self.categories = categories
            }
            .catch { error in
                error.parse()
            }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (tabBarController as? MainTabBarViewController)?.setNonTransparent()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let nextVc = segue.destination as? GrammarCategoryDetailsViewController,
           let category = sender as? GrammarCategory {
            nextVc.category = category
        }
        if let nextVc = segue.destination as? GrammarSubcategoryDetailsViewController,
           let category = sender as? GrammarCategory {
            nextVc.id = category.url
            nextVc.title = category.name
        }
    }
}

extension GrammarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GrammarCategoryCollectionViewCell",
                                                          for: indexPath)
        if let cell = mainCell as? GrammarCategoryCollectionViewCell {
            cell.setUp(categories[indexPath.row])
            return cell
        }
        return mainCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if categories[indexPath.row].hasSubcategories {
            performSegue(withIdentifier: "showSubcategories", sender: categories[indexPath.row])
        } else {
            performSegue(withIdentifier: "showSubcategoryDetails", sender: categories[indexPath.row])
        }
    }
}

extension GrammarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 40 - 18) / 2
        let height = width / 5 * 4
        return CGSize(width: width, height: height)
    }
}
