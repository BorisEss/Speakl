//
//  StoryVideoListViewController.swift
//  stori
//
//  Created by Alex on 20.08.2021.
//

import UIKit

protocol StoryVideoListViewControllerDelegate: AnyObject {
    func beginAnimation()
    func animating(value: CGFloat)
    func endAnimation(value: CGFloat)
}

class StoryVideoListViewController: UIPageViewController {

    var videos: [Video] = []
    
    // Used for pull to refresh animation
    var shouldAnimate: Bool = false
        
    weak var animationDelegate: StoryVideoListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        for view in self.view.subviews where view is UIScrollView {
            (view as? UIScrollView)?.delegate = self
        }
    }
    
    func loadSearch(at item: Int, completion: @escaping () -> Void) {
        self.setViewControllers([UIViewController()], direction: .forward, animated: false) { _ in  }
        downloadData { videos in
            self.videos = videos
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion()
                self.animationDelegate?.endAnimation(value: 0)
                if self.videos.isEmpty {
                    self.setViewControllers([self.prepareNothingFoundController()],
                                            direction: .forward,
                                            animated: false) { _ in  }
                } else {
                    self.setViewControllers([self.prepareVideoController(index: item)],
                                            direction: .forward,
                                            animated: false) { _ in  }
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func loadForYou(completion: @escaping () -> Void) {
        self.setViewControllers([UIViewController()], direction: .forward, animated: false) { _ in  }
        downloadData { videos in
            self.videos = videos
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion()
                self.animationDelegate?.endAnimation(value: 0)
                if self.videos.isEmpty {
                    self.setViewControllers([self.prepareNothingFoundController()],
                                            direction: .forward,
                                            animated: false) { _ in  }
                } else {
                    self.setViewControllers([self.prepareVideoController(index: 0)],
                                            direction: .forward,
                                            animated: false) { _ in  }
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func loadCategory(completion: @escaping () -> Void) {
        self.setViewControllers([UIViewController()], direction: .forward, animated: false) { _ in  }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.videos = []
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion()
                self.animationDelegate?.endAnimation(value: 0)
                if self.videos.isEmpty {
                    self.setViewControllers([self.prepareNothingFoundController()],
                                            direction: .forward,
                                            animated: false) { _ in  }
                } else {
                    self.setViewControllers([self.prepareVideoController(index: 0)],
                                            direction: .forward,
                                            animated: false) { _ in  }
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func loadInProgress(completion: @escaping () -> Void) {
        loadForYou(completion: completion)
    }

    private func downloadData(completion: @escaping (_ videos: [Video]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let url = Bundle.main.url(forResource: "video", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(JsonVideo.self, from: data)
                    completion(jsonData.videos)
                } catch {
                    completion([])
                    print("error:\(error)")
                }
            } else {
                completion([])
            }
        }
    }
}

extension StoryVideoListViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let cIndex = getCurrentIndex(pageViewController: pageViewController)
        if cIndex - 1 < 0 { return nil }
        return prepareVideoController(index: cIndex - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let cIndex = getCurrentIndex(pageViewController: pageViewController)
        if cIndex + 1 >= videos.count { return nil }
        return prepareVideoController(index: cIndex + 1)
    }
    
    func getCurrentIndex(pageViewController: UIPageViewController) -> Int {
        var index: Int = 0
        if let viewController = pageViewController.viewControllers?.first as? StoryVideoViewController,
           let cUrl = viewController.video?.sources {
            index = videos.firstIndex(where: { $0.sources == cUrl }) ?? 0
        }
        return index
    }
    
    func prepareVideoController(index: Int) -> UIViewController {
        let controller = UIStoryboard(name: "Learn",
                                 bundle: nil).instantiateViewController(withIdentifier: "StoryVideoViewController")
        if let storyController = controller as? StoryVideoViewController {
            storyController.setVideo(video: videos[index])
            return storyController
        }
        return controller
    }
    
    func prepareNothingFoundController() -> UIViewController {
        let controller = UIStoryboard(name: "Learn",
                                 bundle: nil).instantiateViewController(withIdentifier: "NothingFoundViewController")
        if let nothingFoundController = controller as? NothingFoundViewController {
            return nothingFoundController
        }
        return controller
    }
}

extension StoryVideoListViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.y >= 0 {
            shouldAnimate = scrollView.isAtTop
            if shouldAnimate {
                animationDelegate?.beginAnimation()
//                print("BEGIN ANIMATION")
            }
        }
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if shouldAnimate {
            let value = scrollView.verticalOffsetForTop - scrollView.contentOffset.y
            animationDelegate?.endAnimation(value: value)
//            print("END: ", value)
            shouldAnimate = false
            if value >= 70 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.animationDelegate?.endAnimation(value: 0)
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if self.videos.isEmpty {
                            self.setViewControllers([self.prepareNothingFoundController()],
                                                    direction: .forward,
                                                    animated: false) { _ in  }
                        } else {
                            self.setViewControllers([self.prepareVideoController(index: 0)],
                                                    direction: .forward,
                                                    animated: false) { _ in  }
                        }
                        self.view.layoutIfNeeded()
//                    }
                }
            }
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if shouldAnimate {
            animationDelegate?.animating(value: scrollView.verticalOffsetForTop - scrollView.contentOffset.y)
//            print(scrollView.verticalOffsetForTop - scrollView.contentOffset.y)
        }
    }
}
