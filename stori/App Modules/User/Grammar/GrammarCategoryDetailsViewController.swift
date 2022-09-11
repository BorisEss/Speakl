//
//  GrammarCategoryDetailsViewController.swift
//  stori
//
//  Created by Alex on 20.07.2022.
//

import UIKit

class GrammarCategoryDetailsViewController: UIViewController {

    var category: GrammarCategory?
    var subcategory: GrammarSubcategory? {
        didSet {
            guard subcategory != nil else { return }
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressActivityIndicator: AppActivityIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let category = category else { return }
        title = category.name
        
        progressActivityIndicator.startAnimating()
        GrammarService().getSubcategories(for: category)
            .ensure {
                self.progressActivityIndicator.stopAnimating()
            }
            .done { subcategory in
                self.subcategory = subcategory
            }
            .catch { error in
                error.parse()
            }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let nextVc = segue.destination as? GrammarSubcategoryDetailsViewController,
           let item = sender as? GrammarSubcategoryItem {
            nextVc.id = item.url
            nextVc.title = item.name
        }
    }
}

extension GrammarCategoryDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = subcategory?.items {
            return items.count + 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let mainCell = tableView.dequeueReusableCell(withIdentifier: "GrammarCategoryExplanationTableViewCell",
                                                         for: indexPath)
            if let cell = mainCell as? GrammarCategoryExplanationTableViewCell {
                cell.descriptionLabel.text = subcategory?.description
                return cell
            }
            return mainCell
        } else {
            let mainCell = tableView.dequeueReusableCell(withIdentifier: "GrammarSubcategoryTableViewCell",
                                                         for: indexPath)
            if let cell = mainCell as? GrammarSubcategoryTableViewCell {
                cell.titleLabel.text = subcategory?.items[indexPath.row - 1].name
                return cell
            }
            return mainCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0, let items = subcategory?.items {
            performSegue(withIdentifier: "showSubcategoryDetails", sender: items[indexPath.row - 1])
        }
    }
}
