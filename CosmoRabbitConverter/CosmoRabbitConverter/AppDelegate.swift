//
//  AppDelegate.swift
//  CosmoRabbitConverter
//
//  Created by CosmoRabbit Converter on 2025/3/4.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import AppsFlyerLib
import FBSDKCoreKit

let appid = "6742783940"

protocol CosmoRabbitAppDelegateInitProtocol {
    func cosmoInitFB(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    func cosmoInitFireBaseAnalyze()
    func cosmoInitAppsFlyer()
    func cosmoInitPush()
}

extension CosmoRabbitAppDelegateInitProtocol {
    
    func cosmoInitFB(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
    }
    
    func cosmoInitFireBaseAnalyze() {
        FirebaseApp.configure()
    }
    
    func cosmoInitAppsFlyer() {
        let appsFlyer = AppsFlyerLib.shared()
        appsFlyer.appsFlyerDevKey = UIViewController.cosmoAppsFlyerDevKey()
        appsFlyer.appleAppID = appid
        appsFlyer.waitForATTUserAuthorization(timeoutInterval: 51)
        appsFlyer.delegate = self as? any AppsFlyerLibDelegate
    }
    
    func cosmoInitPush() {
        UNUserNotificationCenter.current().delegate = self as? any UNUserNotificationCenterDelegate
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
        UIApplication.shared.registerForRemoteNotifications()
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate, CosmoRabbitAppDelegateInitProtocol , AppsFlyerLibDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        cosmoInitFB(application, didFinishLaunchingWithOptions: launchOptions)
        cosmoInitFireBaseAnalyze()
        cosmoInitPush()
        cosmoInitAppsFlyer()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    /// push token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    /// AppsFlyerLibDelegate
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        print("success appsflyer")
    }
    
    func onConversionDataFail(_ error: Error) {
        print("error appsflyer")
    }
    
    /// push
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        completionHandler([[.sound]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        completionHandler()
    }
    
}

