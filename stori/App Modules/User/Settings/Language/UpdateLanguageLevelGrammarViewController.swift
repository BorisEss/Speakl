//
//  UpdateLanguageLevelGrammarViewController.swift
//  stori
//
//  Created by Alex on 04.05.2021.
//

import UIKit
import WebKit

class UpdateLanguageLevelGrammarViewController: UIViewController {

    var language: Language?
    var level: LanguageLevel?
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var noDataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressActivityIndicator.startAnimating()
        
        loadData()
    }
    
    private func loadData() {
        if let language = language,
           let level = level {
            UpdateLanguageLevelService().getGrammar(language: language, languageLevel: level)
                .ensure {
                    self.progressActivityIndicator.stopAnimating()
                }
                .done { url in
                    if let url = URL(string: url) {
                        let request = URLRequest(url: url)
                        self.webView.load(request)
                    } else {
                        self.noDataLabel.isHidden = false
                    }
                }
                .catch { _ in
                    self.noDataLabel.isHidden = false
                }
        } else {
            progressActivityIndicator.stopAnimating()
            noDataLabel.isHidden = false
        }
    }

}
