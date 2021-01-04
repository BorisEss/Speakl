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
    private var progressActivityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addActivityIndicator()
        
        webView.navigationDelegate = self
        
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            noDataLabel.text = "common_nothing_to_show".localized
            noDataLabel.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
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
