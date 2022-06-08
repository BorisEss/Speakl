//
//  WEViewController.swift
//  stori
//
//  Created by Alex on 08.06.2022.
//

import UIKit

class WEViewController: UIViewController {
    
    var vocabularyVc: SelectedWordViewController?
    var grammarVc: WEGrammarViewController?

    @IBOutlet weak var vocabularyButton: UnderlinedButton!
    @IBOutlet weak var grammarButton: UnderlinedButton!
    
    @IBOutlet weak var vocabularyContainer: UIView!
    @IBOutlet weak var grammarContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let nextVc = segue.destination as? SelectedWordViewController {
            vocabularyVc = nextVc
        }
        if let nextVc = segue.destination as? WEGrammarViewController {
            grammarVc = nextVc
        }
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func vocabularyButtonPressed(_ sender: Any) {
        vocabularyContainer.isHidden = false
        grammarContainer.isHidden = true
        vocabularyButton.isChecked = true
        grammarButton.isChecked = false
    }
    
    @IBAction func googleButtonPressed(_ sender: Any) {
        vocabularyContainer.isHidden = true
        grammarContainer.isHidden = false
        vocabularyButton.isChecked = false
        grammarButton.isChecked = true
    }
}
