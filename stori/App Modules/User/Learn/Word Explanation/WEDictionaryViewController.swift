//
//  WEDictionaryViewController.swift
//  stori
//
//  Created by Alex on 04.01.2022.
//

import UIKit

class WEDictionaryViewController: UIViewController {

    weak var scrollDelegate: UICustomScrollDelegate?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var wordImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        wordImageView.load(stringUrl: "https://s3-us-west-2.amazonaws.com/utsw-patientcare-web-production/original_images/rhinoplasty-nose-surgery-1600x732.jpg")
    }
    
}

extension WEDictionaryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidScroll(scrollView)
    }
}
