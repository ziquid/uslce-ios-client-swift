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
    
    var settingsDict = [String: Any]()

    // iOS TTS
    var utterance: AVSpeechUtterance = AVSpeechUtterance(string: "");
    let synthesizer = AVSpeechSynthesizer()

    // IBM Text to Speech service object
//    var textToSpeech: TextToSpeech!
    var soundPlayer: AVAudioPlayer?

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        let noAudiovisualMediaType: WKAudiovisualMediaTypes = []
        webConfiguration.mediaTypesRequiringUserActionForPlayback = noAudiovisualMediaType
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.contentMode = .scaleAspectFill
        webView.uiDelegate = self

        // Clear caches.
        URLCache.shared.removeAllCachedResponses()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        print("here we go again!")
        
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
            case .mac:
                deviceType = "Mac"
                break
            @unknown default:
                deviceType = "iUnknown"
                break
        }

        let defaults = UserDefaults.standard
        let authKeyWrapped = defaults.string(forKey: "authKey")
        var authKey = ""
        var deviceOrientation = "portrait"
        var deviceWidth = "320"
        var deviceHeight = "480"
        var userAgent = "unknown userAgent"
        var customUserAgent = "unknown customUserAgent"
        
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

        webView.evaluateJavaScript("screen.width + ''") { (result, error) in
            if let result = result {
                os_log("screen.width: %@", type: .debug, result as! CVarArg);
                deviceWidth = result as! String
            }
            else {
                os_log("screen.width returned error: %@", type: .debug, error! as CVarArg);
            }
        }
        
        webView.evaluateJavaScript("screen.height + ''") { (result, error) in
            if let result = result {
                os_log("screen.height: %@", type: .debug, result as! CVarArg);
                deviceHeight = result as! String
            }
            else {
                os_log("screen.height returned error: %@", type: .debug, error! as CVarArg);
            }
        }
        
        if UIDevice.current.orientation.isLandscape {
            deviceOrientation = "landscape";
        }
        os_log("device orientation: %@", type: .info, deviceOrientation);
        
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        if UIDevice.current.orientation.isLandscape {
            game = "usl_esa"
        } else {
            game = "stlouis"
        }
        
        //        os_log("UUID: %@", type: .info, uuidPrefix + uuid!)
        //        #ifdef DEBUG
//        let myURL = "http://uslce.lndo.site/" + game + "/bounce/" + uuid!
        //        #else
         let myURL = "http://zg.games.ziquid.com/" + game + "/bounce/" + uuid!
        //        #endif
        os_log("URL: %@", type: .info, myURL)
        
        webView.evaluateJavaScript("navigator.userAgent") { (result, error) in
            if let result = result {
                os_log("navigator.userAgent: %@", type: .debug, result as! CVarArg);
                userAgent = result as! String
                customUserAgent = " (com.ziquid.uslce; " + versionStr + "; width=" + deviceWidth + "; height=" + deviceHeight +
                    "; orientation=" + deviceOrientation + "; authKey=" + authKey + ")"
                os_log("custom user agent: %@", type: .info, customUserAgent as CVarArg)
                self.webView.customUserAgent = userAgent + customUserAgent
                let myRequest = URLRequest(url: URL(string: myURL)!)
                self.webView.load(myRequest)
            }
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        os_log("viewWillTransition!")
        super.viewWillTransition(to: size, with: coordinator)
        self.viewDidLoad() // reload view
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let scheme = navigationAction.request.url?.scheme
        if (navigationAction.targetFrame == nil || scheme == "external") {
            print(navigationAction.request.url?.absoluteString as Any)
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
        
        settingsDict = [:]
        if (self.soundPlayer?.isPlaying != nil) {
            self.soundPlayer?.stop()
        }
        
        // Speech.
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
        
        self.getSetting(setting: "sound", callbackIfSet: self.getNumberOfLoops)
        
        // Sound played once.
//        webView.evaluateJavaScript("Drupal.settings.zg.sound") { (result, error) in
//            if (error == nil) {
//                if let result = result {
//                    let soundFile = (result as! String)
//
//                    webView.evaluateJavaScript("Drupal.settings.zg.numberOfLoops") { (loopResult, error) in
//                        if (error == nil) {
//                            if let loopResult = loopResult {
//                                let numberOfLoopsString = (loopResult as! String)
//                                let numberOfLoops = Int(numberOfLoopsString) ?? 0
//
//                                self.checkIfLinkExists(withLink: soundFile) {
//                                    [weak self] downloadedURL in
//                                    guard let self = self else {
//                                        return
//                                    }
//                                    self.playUrl(url: downloadedURL, numberOfLoops: numberOfLoops)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            else {
////                os_log("cannot find zg sound because of error: %@", type: .error, error! as CVarArg);
//            }
//        }
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
    
    // Get a Drupal setting.
    func getSetting(setting: String, callbackIfSet: @escaping (String) -> Void) {
        webView.evaluateJavaScript("Drupal.settings.zg." + setting) { (result, error) in
//            print("callbackIfSet: \(callbackIfSet)")
            if (error == nil) {
                if let result = result {
                    let resultString = (result as! String)
                    self.settingsDict[setting] = resultString
                    print ("settings dictionary: \(self.settingsDict)")
                    callbackIfSet(resultString)
                }
            }
        }
    }
    
    
    func getNumberOfLoops(sound: String) {
        print("getNumberofLoops is called with parameter \(sound)")
        print ("settings dictionary: \(self.settingsDict)")
        self.getSetting(setting: "numberOfLoops", callbackIfSet: self.playSoundWithLoops)
    }
    
    func playSoundWithLoops(loops: String) {
        print("playSoundWithLoops is called with parameter \(loops)")
        print ("settings dictionary: \(self.settingsDict)")
        let soundFile = self.settingsDict["sound"] as! String
        
        self.checkIfLinkExists(withLink: soundFile) {
            [weak self] downloadedURL in
            guard let self = self else {
                return
            }
            self.playUrl(url: downloadedURL, numberOfLoops: Int(loops) ?? 0)
        }
    }
        
    func playSound(sound: String, numberOfLoops: Int = 0) {
        print("Attempting to play sound \(String(describing: sound)), looping \(numberOfLoops) times")
        let soundUrl = Bundle.main.url(forResource: sound, withExtension: "mp3")!
        playUrl(url: soundUrl, numberOfLoops: numberOfLoops)
    }

    func playUrl(url: URL, numberOfLoops: Int = 0) {
        print("Attempting to play sound from URL \(url), looping \(numberOfLoops) times")

        do {
            self.soundPlayer = try AVAudioPlayer(contentsOf: url)
            self.soundPlayer?.prepareToPlay()
            self.soundPlayer?.numberOfLoops = numberOfLoops
//            soundPlayer?.delegate = self
            self.soundPlayer?.play()
//            let percentage = (soundPlayer?.currentTime ?? 0)/(soundPlayer?.duration ?? 1)
//            DispatchQueue.main.async {
                // do what ever you want with that "percentage"
//            }

        } catch _ {
            self.soundPlayer = nil
        }

    }

    func downloadFile(withUrl url: URL, andFilePath filePath: URL, completion: @escaping ((_ filePath: URL)->Void)) {
        print("Attempting to download file \(String(describing: url)) at path \(String(describing: filePath))")
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data.init(contentsOf: url)
                try data.write(to: filePath, options: .atomic)
                print("saved at \(filePath.absoluteString)")
                DispatchQueue.main.async {
                    completion(filePath)
                }
            }
            catch {
                print("an error happened while downloading or saving the file")
            }
        }
    }

    func checkIfLinkExists(withLink link: String, completion: @escaping ((_ filePath: URL)->Void)) {
        print("Checking to see if link exists: \(link)")
        let urlString = link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if let url  = URL.init(string: urlString ?? "") {
            let fileManager = FileManager.default
            if let documentDirectory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
                let filePath = documentDirectory.appendingPathComponent(url.lastPathComponent, isDirectory: false)
                do {
                    if try filePath.checkResourceIsReachable() {
                        print("file already exists; no download needed.")
                        completion(filePath)
                    }
                    else {
                        print("file doesnt exist; attempting download.")
                        downloadFile(withUrl: url, andFilePath: filePath, completion: completion)
                    }
                }
                catch {
                    print("file doesnt exist; attempting download.")
                    downloadFile(withUrl: url, andFilePath: filePath, completion: completion)
                }
            }
            else {
                 print("error: cannot find document directory.")
            }
        }
        else {
            print("error: url isnt valid.")
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

