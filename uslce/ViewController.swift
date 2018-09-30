//
//  ViewController.swift
//  uslce
//
//  Created by Joseph Cheek on 3/3/18.
//  Copyright © 2018 Ziquid Design Studio, LLC. All rights reserved.
//

import UIKit
import WebKit
import os.log

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.contentMode = .scaleAspectFill
        webView.uiDelegate = self
        
        // Clear caches.
        URLCache.shared.removeAllCachedResponses()
        
        // Set user agent.
        var deviceType = "iPhone"
        switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                deviceType = "iPhone"
                break
            case .pad:
                deviceType = "iPad"
                break
            case .unspecified:
                deviceType = "iUnknown"
                break
            case .tv:
                deviceType = "appleTV"
                break
            case .carPlay:
                deviceType = "carPlay"
                break
        }
        
        let defaults = UserDefaults.standard
        let authKeyWrapped = defaults.string(forKey: "authKey")
        var authKey = ""
        
        if let authKeyTest = authKeyWrapped /* as? String */ {
            authKey = authKeyTest
            os_log("retrieved authKey: %@", type: .info, authKey)
        }
        else {
            authKey = UUID().uuidString
            defaults.set(authKey, forKey: "authKey")
            os_log("new authKey: %@", type: .info, authKey)
        }
        
        let versionStr = deviceType + "/" + Bundle.main.releaseVersionNumber! + "/" + Bundle.main.buildVersionNumber!
        let deviceWidth = (UIWebView().stringByEvaluatingJavaScript(from: "screen.width") ?? "320")
        os_log("screen width: %@", type: .info, deviceWidth);
        let customUserAgent = " (com.ziquid.uslce; " + versionStr + "; width=" + deviceWidth + "; authKey=" + authKey + ")"
        webView.customUserAgent = (UIWebView().stringByEvaluatingJavaScript(from: "navigator.userAgent") ?? "") + customUserAgent
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        os_log("UUID: %@", type: .info, uuid!)
        let myURL = URL(string: "http://uslce.games.ziquid.com/stlouis/bounce/" + uuid!)
        let myRequest = URLRequest(url: myURL!)
        webView.navigationDelegate = self
        webView.load(myRequest)
        webView.allowsBackForwardNavigationGestures = false
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let scheme = navigationAction.request.url?.scheme
        if (navigationAction.targetFrame == nil || scheme == "external") {
//            print(navigationAction.request.url?.absoluteString)
            let urlString = navigationAction.request.url!.absoluteString;
            let newUrlString = urlString.replacingOccurrences(of: "external://", with: "http://")
            let newUrl = URL(string: newUrlString)
            UIApplication.shared.open(newUrl!)
            decisionHandler(.cancel)
        }
        else {
//            print("Open it locally")
            decisionHandler(.allow)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
