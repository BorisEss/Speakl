//
//  MainStoryVideoListViewController.swift
//  stori
//
//  Created by Alex on 23.12.2021.
//

import UIKit

class MainStoryVideoListViewController: UIViewController {

    @IBOutlet weak var activityIndicator: AppActivityIndicator!
    @IBOutlet weak var cView: UIView!
    
    var position: Int = 0
    
    private var storiesListVc: StoryVideoListViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        storiesListVc?.loadSearch(at: position, completion: {
            self.activityIndicator.stopAnimating()
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVc = segue.destination as? StoryVideoListViewController {
            self.storiesListVc = nextVc
//            nextVc.animationDelegate = self
        }
        super.prepare(for: segue, sender: sender)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
