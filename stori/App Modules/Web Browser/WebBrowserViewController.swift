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
    var noDataTitle: String?
    var navbarWasHidden: Bool = false
    private var progressActivityIndicator: UIActivityIndicatorView!

    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var noDataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addActivityIndicator()
        
        webView.navigationDelegate = self
        
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            if let noDataTitle = noDataTitle {
                noDataLabel.text = noDataTitle
            } else {
                noDataLabel.text = "common_nothing_to_show".localized
            }
            noDataLabel.isHidden = false
            webView.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navbarIsHidden = navigationController?.navigationBar.isHidden,
           navbarIsHidden {
            navbarWasHidden = true
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if navbarWasHidden {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    private func addActivityIndicator() {
        progressActivityIndicator = UIActivityIndicatorView()
        progressActivityIndicator.style = .medium
        progressActivityIndicator.hidesWhenStopped = true
        let loading = UIBarButtonItem(customView: progressActivityIndicator)
        navigationItem.rightBarButtonItem = loading
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
