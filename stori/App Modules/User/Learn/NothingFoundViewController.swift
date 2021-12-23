//
//  NothingFoundViewController.swift
//  stori
//
//  Created by Alex on 09.12.2021.
//

import UIKit
import SwiftyGif

class NothingFoundViewController: UIViewController {

    @IBOutlet weak var iconView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            let gif = try UIImage(gifName: "eyes.gif")
            iconView.setGifImage(gif, loopCount: -1)
        } catch {
            print(error)
        }
    }

}
