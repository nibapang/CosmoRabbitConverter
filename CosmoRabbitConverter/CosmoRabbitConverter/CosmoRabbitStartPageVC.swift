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
        startLoadingAnimation()
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
