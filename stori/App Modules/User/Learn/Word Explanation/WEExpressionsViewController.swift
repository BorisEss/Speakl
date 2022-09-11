//
//  WEExpressionsViewController.swift
//  stori
//
//  Created by Alex on 04.01.2022.
//

import UIKit

class WEExpressionsViewController: UIViewController {

    weak var scrollDelegate: UICustomScrollDelegate?

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension WEExpressionsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidScroll(scrollView)
    }
}
