//
//  StoryVideoListViewController.swift
//  stori
//
//  Created by Alex on 20.08.2021.
//

import UIKit

class StoryVideoListViewController: UIPageViewController {

    var videos: [Video] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videos = loadJson()
        delegate = self
        dataSource = self
        setViewControllers([prepareVideoController(index: 0)], direction: .forward, animated: true) { _ in  }
    }
    
    func loadJson() -> [Video] {
        if let url = Bundle.main.url(forResource: "video", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(JsonVideo.self, from: data)
                return jsonData.videos
            } catch {
                print("error:\(error)")
            }
        }
        return []
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
}
