//
//  TutorialPagesViewController.swift
//  stori
//
//  Created by Alex on 23.12.2021.
//

import UIKit

// MARK: - Tutorial Protocol
protocol TutorialPagesViewControllerDelegate: AnyObject {
    func didChangeIndex(index: Int)
}

// MARK: - Tutorial Value definition
typealias TutorialValue = (id: Int, image: UIImage?, description: String)

// MARK: - TutorialPagesViewController
class TutorialPagesViewController: UIPageViewController {

    // MARK: - Variables
    private let tutorialItems: [TutorialValue] = [
        (1, UIImage(named: "welcome_item_first"), "start_tutorial_vc_page_one_title".localized),
        (2, UIImage(named: "welcome_item_second"), "start_tutorial_vc_page_two_title".localized),
        (3, UIImage(named: "welcome_item_third"), "start_tutorial_vc_page_three_title".localized)
    ]
    
    weak var tutorialPagesDelegate: TutorialPagesViewControllerDelegate?
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let controller = UIStoryboard(name: "Tutorial",
                                 bundle: nil).instantiateViewController(withIdentifier: "TutorialItemViewController")
        if let nothingFoundController = controller as? TutorialItemViewController {
            self.setViewControllers([nothingFoundController],
                                    direction: .forward,
                                    animated: false) { _ in  }
        }
        
        delegate = self
        dataSource = self
    }

}

// MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource
extension TutorialPagesViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let cIndex = getCurrentIndex(pageViewController: pageViewController)
        if cIndex - 1 < 0 { return nil }
        return prepareVideoController(index: cIndex - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let cIndex = getCurrentIndex(pageViewController: pageViewController)
        if cIndex + 1 >= tutorialItems.count { return nil }
        return prepareVideoController(index: cIndex + 1)
    }
    
    func getCurrentIndex(pageViewController: UIPageViewController) -> Int {
        var index: Int = 0
        if let viewController = pageViewController.viewControllers?.first as? TutorialItemViewController,
           let item = viewController.item {
            index = tutorialItems.firstIndex(where: { $0.id == item.id }) ?? 0
            tutorialPagesDelegate?.didChangeIndex(index: index)
        }
        return index
    }
    
    func prepareVideoController(index: Int) -> UIViewController {
        let controller = UIStoryboard(name: "Tutorial",
                                 bundle: nil).instantiateViewController(withIdentifier: "TutorialItemViewController")
        if let tutorialController = controller as? TutorialItemViewController {
            tutorialController.setUp(tutorialItems[index])
            return tutorialController
        }
        return controller
    }
}
