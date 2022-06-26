//
//  AnonymousTranslationViewController.swift
//  stori
//
//  Created by Alex on 26.06.2022.
//

import UIKit
import SwiftyGif

class AnonymousTranslationViewController: UIViewController {

    @IBOutlet weak var eyeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            let gif = try UIImage(gifName: "eyes.gif")
            eyeImageView.setGifImage(gif, loopCount: -1)
        } catch {
            print(error)
        }
    }

}
