//
//  ImagePreviewViewController.swift
//  stori
//
//  Created by Alex on 06.01.2021.
//

import UIKit

class ImagePreviewViewController: UIViewController {

    // MARK: - Variables
    var image: UIImage?
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var noDataLabel: UILabel!
    
    // MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        
        if image == nil {
            noDataLabel.isHidden = false
            scrollView.isHidden = true
        }
    }
}

// MARK: - UIScrollViewDelegate
extension ImagePreviewViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
