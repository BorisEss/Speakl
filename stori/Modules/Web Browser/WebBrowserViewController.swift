//
//  WebBrowserViewController.swift
//  stori
//
//  Created by Alex on 03.12.2020.
//

import UIKit
import WebKit

class WebBrowserViewController: UIViewController {
    
    var url: URL?
    var navigation: Bool = false
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var progressActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if navigation {
            closeButton.setTitle("common_back_title".localized, for: .normal)
        } else {
            closeButton.setTitle("common_close_title".localized, for: .normal)
        }
        
        webView.navigationDelegate = self
        
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        if navigation {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension WebBrowserViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressActivityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressActivityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressActivityIndicator.stopAnimating()
    }
}
