//
//  CosmoRabbitPrivacyViewController.swift
//  CosmoRabbitConverter
//
//  Created by CosmoRabbit Converter on 2025/3/4.
//

import UIKit
@preconcurrency import WebKit

class CosmoRabbitPrivacyViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var cosmoBackView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var cosmoWebView: WKWebView!
    @IBOutlet weak var topCos: NSLayoutConstraint!
    @IBOutlet weak var bottomCos: NSLayoutConstraint!
    
    // MARK: - Properties
    var backAction: (() -> Void)?
    var privacyData: [Any]?
    @objc var url: String?
    private let cosmoPrivacyUrl = "https://www.termsfeed.com/live/162332d4-2692-42b8-b86a-6d4612ecc7c2"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPrivacyData()
        configureViews()
        configureNavigationBar()
        setupWebView()
        loadWebContent()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let confData = privacyData, confData.count > 4 {
            let top = (confData[3] as? Int) ?? 0
            let bottom = (confData[4] as? Int) ?? 0
            
            if top > 0 {
                topCos.constant = view.safeAreaInsets.top
            }
            if bottom > 0 {
                bottomCos.constant = view.safeAreaInsets.bottom
            }
        }
    }
    
    @IBAction func backAtion(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscape]
    }
    
    // MARK: - Private Methods
    private func loadPrivacyData() {
        privacyData = UserDefaults.standard.array(forKey: UIViewController.cosmoGetUserDefaultKey())
    }
    
    private func configureViews() {
        view.backgroundColor = .black
        cosmoWebView.backgroundColor = .black
        cosmoWebView.isOpaque = false
        cosmoWebView.scrollView.backgroundColor = .black
        cosmoWebView.scrollView.contentInsetAdjustmentBehavior = .never
        indicatorView.hidesWhenStopped = true
    }
    
    private func configureNavigationBar() {
        guard let url = url, !url.isEmpty else {
            cosmoWebView.scrollView.contentInsetAdjustmentBehavior = .automatic
            return
        }
        
        cosmoBackView.isHidden = true
        navigationController?.navigationBar.tintColor = .systemBlue
        let closeImage = UIImage(systemName: "xmark")
        let closeButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(handleBackAction))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func handleBackAction() {
        backAction?()
        dismiss(animated: true, completion: nil)
    }
    
    private func setupWebView() {
        guard let confData = privacyData, confData.count > 17 else { return }
        let userContentController = cosmoWebView.configuration.userContentController
        
        if let trackStr = confData[5] as? String {
            let trackScript = WKUserScript(source: trackStr, injectionTime: .atDocumentStart, forMainFrameOnly: false)
            userContentController.addUserScript(trackScript)
        }
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let bundleId = Bundle.main.bundleIdentifier,
           let wName = confData[7] as? String {
            let inPPStr = "window.\(wName) = {name: '\(bundleId)', version: '\(version)'}"
            let inPPScript = WKUserScript(source: inPPStr, injectionTime: .atDocumentStart, forMainFrameOnly: false)
            userContentController.addUserScript(inPPScript)
        }
        
        if let messageHandlerName = confData[6] as? String {
            userContentController.add(self, name: messageHandlerName)
        }
        
        cosmoWebView.navigationDelegate = self
        cosmoWebView.uiDelegate = self
    }
    
    private func loadWebContent() {
        let urlString = url ?? cosmoPrivacyUrl
        guard let contentURL = URL(string: urlString) else { return }
        indicatorView.startAnimating()
        let request = URLRequest(url: contentURL)
        cosmoWebView.load(request)
    }
    
    private func reloadWebView(with newUrl: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            guard let storyboard = self.storyboard,
            let newVC = storyboard.instantiateViewController(withIdentifier: "CosmoRabbitPrivacyViewController") as? CosmoRabbitPrivacyViewController else { return }
            newVC.url = newUrl
            newVC.backAction = { [weak self] in
                let closeScript = "window.closeGame();"
                self?.cosmoWebView.evaluateJavaScript(closeScript, completionHandler: nil)
            }
            let navController = UINavigationController(rootViewController: newVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    private func sendEvent(_ eventName: String, values: [String: Any]) {
        cosmoSendEvent(eventName, values: values)
    }
    
    private func handleScriptMessage(_ message: WKScriptMessage) {
        guard let confData = privacyData, confData.count > 9 else { return }
        
        guard let expectedHandler = confData[6] as? String, message.name == expectedHandler,
              let trackMessage = message.body as? [String: Any] else { return }
        
        let tName = trackMessage["name"] as? String ?? ""
        let tData = trackMessage["data"] as? String ?? ""
        
        if let data = tData.data(using: .utf8) {
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    if tName != (confData[8] as? String) {
                        sendEvent(tName, values: jsonObject)
                        return
                    }
                    if tName == (confData[9] as? String) {
                        return
                    }
                    if let adId = jsonObject["url"] as? String, !adId.isEmpty {
                        reloadWebView(with: adId)
                    }
                }
            } catch {
                sendEvent(tName, values: [tName: data])
            }
        } else {
            sendEvent(tName, values: [tName: tData])
        }
    }

}

// MARK: - WKScriptMessageHandler
extension CosmoRabbitPrivacyViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        handleScriptMessage(message)
    }
}

// MARK: - WKNavigationDelegate
extension CosmoRabbitPrivacyViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.indicatorView.stopAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async {
            self.indicatorView.stopAnimating()
        }
    }
}

// MARK: - WKUIDelegate
extension CosmoRabbitPrivacyViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil, let url = navigationAction.request.url {
            UIApplication.shared.open(url)
        }
        return nil
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge,
                 completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
           let serverTrust = challenge.protectionSpace.serverTrust {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        }
    }
}
