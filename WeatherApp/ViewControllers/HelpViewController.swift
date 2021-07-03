//
//  HelpViewController.swift
//  WeatherApp
//
//  Created by Prashant Gaikwad on 03/07/21.
//

import UIKit
import WebKit

class HelpViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        let url = URL(string: "https://github.com/PrashantGaikwad-iOS/WeatherApp/blob/PrashantFeature/README.md")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}
