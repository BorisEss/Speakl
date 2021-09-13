//
//  LearnViewController.swift
//  stori
//
//  Created by Alex on 19.08.2021.
//

import UIKit
import SwipeMenuViewController

class LearnViewController: UIViewController {

    var tabs: [String] = [
        "For You",
        "Animals",
        "Appearence",
        "Communication",
        "Culture",
        "Food,Drink",
        "Functions",
        "Health"
    ]
    
    @IBOutlet weak var swipeMenuView: SwipeMenuView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeMenuView.dataSource = self
        swipeMenuView.delegate = self

        var options: SwipeMenuViewOptions = .init()
        options.tabView.height = 50
        options.tabView.margin = 8
        options.tabView.addition = .underline
        options.tabView.additionView.backgroundColor = .clear
        options.tabView.itemView.font = .IBMPlexSans(size: 16)
        options.tabView.itemView.selectedTextColor = .white
        options.tabView.itemView.margin = 12
        
        swipeMenuView.reloadData(options: options)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (tabBarController as? MainTabBarViewController)?.setTransparent()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension LearnViewController: SwipeMenuViewDelegate, SwipeMenuViewDataSource {
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewControllerForPageAt index: Int) -> UIViewController {
        return UIViewController()
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, titleForPageAt index: Int) -> String {
        return tabs[index]
    }
    
    func numberOfPages(in swipeMenuView: SwipeMenuView) -> Int {
        tabs.count
    }
    
}
