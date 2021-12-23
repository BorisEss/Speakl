//
//  MainTabBarViewController.swift
//  stori
//
//  Created by Alex on 18.12.2020.
//

import UIKit
import EasyTipView

class MainTabBarViewController: UITabBarController {
    
    private var addButton = UIButton()
    private var tipView: EasyTipView?
    
    let item1 = UIStoryboard(name: "Learn",
                             bundle: nil).instantiateViewController(withIdentifier: "MainViewController")
//    let item2 = UIStoryboard(name: "Learn",
//                             bundle: nil).instantiateViewController(withIdentifier: "LearnViewController")
    let item3 = UIStoryboard(name: "Settings",
                             bundle: nil).instantiateViewController(withIdentifier: "MainNavigationViewController")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTransparent()

        loadTabButtons()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 25)
    }
    
    private func loadTabButtons() {
        item1.tabBarItem = UITabBarItem(title: "main_nav_controller_tab_title_learn".localized,
                                        image: UIImage(named: "learnTab"), tag: 0)
//        item2.tabBarItem = UITabBarItem(title: "main_nav_controller_tab_title_vocabulary".localized,
//                                        image: UIImage(named: "vocabularyTab"), tag: 0)
        item3.tabBarItem = UITabBarItem(title: "main_nav_controller_tab_title_profile".localized,
                                        image: UIImage(named: "profileTab"), tag: 0)

        viewControllers = [item1, item3]// , item2, item3]
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateTitles),
                                               name: .updateLanguage,
                                               object: nil)
//        loadAddButton()
    }
    
    private func loadAddButton() {
        guard let tabItems = tabBar.items else { return }
        tabItems[0].titlePositionAdjustment = UIOffset(horizontal: -10, vertical: 0) // -5
        tabItems[1].titlePositionAdjustment = UIOffset(horizontal: 10, vertical: 0) // 5
//        tabItems[1].titlePositionAdjustment = UIOffset(horizontal: -20, vertical: 0)
//        tabItems[2].titlePositionAdjustment = UIOffset(horizontal: 20, vertical: 0)
//        tabItems[3].titlePositionAdjustment = UIOffset(horizontal: 5, vertical: 0)
        addButton.frame.size = CGSize(width: 50, height: 50)
        addButton.setImage(UIImage(named: "add_stori_icon_white"), for: .normal)
        addButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 25)
        tabBar.addSubview(addButton)
        
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.showToolTip),
                                               name: .showAddStoriToolTip,
                                               object: nil)
    }
    
    @objc private func showToolTip() {
        var preferences = EasyTipView.globalPreferences
        // Tip Bubble UI
        preferences.drawing.backgroundColor = UIColor.accentColor
        preferences.drawing.arrowPosition = .bottom
        preferences.drawing.arrowHeight = 8
        preferences.drawing.arrowWidth = 16
        preferences.drawing.cornerRadius = 4

        // Tip Shadow
        preferences.drawing.shadowColor = .black
        preferences.drawing.shadowOffset = CGSize(width: 0, height: 8)
        preferences.drawing.shadowRadius = 16
        preferences.drawing.shadowOpacity = 0.2
        
        // Tip Animation
        preferences.animating.dismissTransform = CGAffineTransform(translationX: 0, y: 15)
        preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: 15)
        preferences.animating.showInitialAlpha = 0
        preferences.animating.showDuration = 1
        preferences.animating.dismissDuration = 1
        
        // Tip Content
//        preferences.positioning.contentHInset = 8
//        preferences.positioning.contentVInset = 8
        
        let tipTitleLabel = UILabel()
        tipTitleLabel.font = .IBMPlexSans(size: 14)
        tipTitleLabel.text = "main_nav_controller_tip_title".localized
        tipTitleLabel.textAlignment = .center
        tipTitleLabel.textColor = .white
        
        let tipSubtitleLabel = UILabel()
        tipSubtitleLabel.font = .IBMPlexSans(size: 10)
        tipSubtitleLabel.text = "main_nav_controller_tip_subtitle".localized
        tipSubtitleLabel.textAlignment = .center
        tipSubtitleLabel.textColor = .white
        
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 91, height: 44))
        stackView.spacing = 4
        stackView.axis = .vertical
        stackView.addArrangedSubview(tipTitleLabel)
        stackView.addArrangedSubview(tipSubtitleLabel)
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: 91, height: 44))
        contentView.addSubview(stackView)
        stackView.center = CGPoint(x: contentView.center.x, y: contentView.center.y-3)
        tipView = EasyTipView(contentView: contentView, preferences: preferences)
        tipView?.show(forView: self.addButton)
    }
    
    @objc func updateTitles() {
        item1.title = "main_nav_controller_tab_title_learn".localized
//        item2.title = "main_nav_controller_tab_title_vocabulary".localized
        item3.title = "main_nav_controller_tab_title_profile".localized
    }
    
    @objc func addButtonPressed(sender: UIButton!) {
        tipView?.dismiss()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Teacher", bundle: nil)
        let identifier = "TeacherNetworkViewController"
        let controller = storyBoard.instantiateViewController(withIdentifier: identifier)
        if let nextScreen = controller as? TeacherNetworkViewController {
            UIApplication.getTopViewController()?.navigationController?.pushViewController(nextScreen, animated: true)
        }
    }
    
    func setTransparent() {
        tabBar.isTranslucent = true
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.backgroundColor = .clear
        tabBar.barTintColor = .clear
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .white.withAlphaComponent(0.5)
        addButton.setImage(UIImage(named: "add_stori_icon_white"), for: .normal)
    }
    
    func setNonTransparent() {
        tabBar.isTranslucent = true
        tabBar.shadow = true
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.15
        tabBar.backgroundColor = .white
        tabBar.tintColor = .accentColor
        tabBar.barTintColor = .white
        tabBar.unselectedItemTintColor = .lightGray
        addButton.setImage(UIImage(named: "add_stori_icon_yellow"), for: .normal)
    }
}
