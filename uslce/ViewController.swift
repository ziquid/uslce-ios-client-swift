//
//  ViewController.swift
//  uslce
//
//  Created by Joseph Cheek on 3/3/18.
//  Copyright © 2018 Ziquid Design Studio, LLC. All rights reserved.
//

//import TextToSpeechV1
import AVFoundation
import UIKit
import WebKit
import os.log

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var webView: WKWebView!
    var game = ""
    
    // iOS TTS
    var utterance: AVSpeechUtterance = AVSpeechUtterance(string: "");
    let synthesizer = AVSpeechSynthesizer()
    
    // IBM Text to Speech service object
//    var textToSpeech: TextToSpeech!
    var soundPlayer: AVAudioPlayer?
    
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
        let deviceHeight = (UIWebView().stringByEvaluatingJavaScript(from: "screen.height") ?? "480")
        os_log("screen height: %@", type: .info, deviceHeight);
        let customUserAgent = " (com.ziquid.uslce; " + versionStr + "; width=" + deviceWidth + "; height=" + deviceHeight + "; authKey=" + authKey + ")"
        webView.customUserAgent = (UIWebView().stringByEvaluatingJavaScript(from: "navigator.userAgent") ?? "") + customUserAgent
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let text = "I like what I see."
        
        // iOS TTS
//        utterance = AVSpeechUtterance(string: text)
//        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
//        print(AVSpeechSynthesisVoice.speechVoices())
//        synthesizer.speak(utterance)
        
        // Instantiate IBM TTS
//        textToSpeech = TextToSpeech(
//            username: Credentials.TextToSpeechUsername,
//            password: Credentials.TextToSpeechPassword
//        )
//        talk(text: "This is a call to the talk method.")
        
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        if UIDevice.current.orientation.isLandscape {
            game = "usl_esa"
        } else {
            game = "stlouis"
        }
//        os_log("UUID: %@", type: .info, uuidPrefix + uuid!)
//        #ifdef DEBUG
//              let myURL = "http://usl15.dd:8083/" + game + "/bounce/" + uuid!
//        #else
            let myURL = "http://uslce.games.ziquid.com/" + game + "/bounce/" + uuid!
//        #endif
        os_log("URL: %@", type: .info, myURL)
        let myRequest = URLRequest(url: URL(string: myURL)!)
        webView.navigationDelegate = self
        webView.load(myRequest)
        webView.allowsBackForwardNavigationGestures = false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.viewDidLoad() // reload view
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
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        let url = webView.url?.absoluteString
//        print("---didFinish() Hitted URL--->\(url!)") // here you are getting URL
        webView.evaluateJavaScript("Drupal.settings.zg.speech") { (result, error) in
            if (error == nil) {
                if result != nil {
//                    self.talk(text: result as! String)
                }
            }
            else {
//                print("cannot find stlouis speech because of \(String(describing: error))")
//                os_log("error: %@", type: .error, error! as CVarArg);
            }
        }
        webView.evaluateJavaScript("Drupal.settings.zg.sound") { (result, error) in
            if (error == nil) {
                if result != nil {
                    let soundFile = (result as! String)
                    self.playSound(sound: soundFile)
                }
            }
            else {
                print("cannot find zg sound because of \(String(describing: error))")
                os_log("error: %@", type: .error, error! as CVarArg);
            }
        }
    }
    
    func talk(text: String) {
        utterance = AVSpeechUtterance(string: text)
//        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        //        print(AVSpeechSynthesisVoice.speechVoices())
//                synthesizer.speak(utterance)
        
        // Synthesize the text
//        let failure = { (error: Error) in print(error) }
//        let voice = "en-US_MichaelVoice"
//        textToSpeech.synthesize(
//            text: text,
//            accept: "audio/wav",
//            voice: voice,
//            failure: failure)
//        {
//            data in
//            do {
//                self.player = try AVAudioPlayer(data: data)
//                self.player!.play()
//            } catch {
//                print("Failed to create audio player.")
//            }
//        }
    }
    
    func playSound(sound: String) {
//        do {
            let soundUrl = Bundle.main.url(forResource: sound, withExtension: "mp3")!
            print("Attempting to play sound \(String(describing: sound))")
        
//        } catch let error {
//            print(error.localizedDescription)
//            return
//        }

        do {
            soundPlayer = try AVAudioPlayer(contentsOf: soundUrl)
            soundPlayer?.play()
        } catch {
            // couldn't load file :(
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

