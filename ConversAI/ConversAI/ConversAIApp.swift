//
//  ConversAIApp.swift
//  ConversAI
//
//  Created by Murat ÖZTÜRK on 3.06.2023.
//
import GoogleMobileAds
import SwiftUI
import RevenueCat



import UIKit
import AppsFlyerLib
import AppTrackingTransparency

@main
struct ConversAIApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var upgradeViewModel = UpgradeViewModel()

    
    @AppStorage(Constants.Preferences.DARK_MODE)
    private var isDarkTheme = UserDefaults.isDarkTheme
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            SplashView()
                .preferredColorScheme(isDarkTheme ? .dark : .light)
                .environmentObject(upgradeViewModel)

        }  .onChange(of: scenePhase) { (newScenePhase) in
            if case .active = newScenePhase {
                initMobileAds()
            }
        }
    }

    
      func initMobileAds() {
          GADMobileAds.sharedInstance().start(completionHandler: nil)
          // comment this if you want SDK Crash Reporting:
          GADMobileAds.sharedInstance().disableSDKCrashReporting()
      }
    
    init() {
        
//        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: Constants.REVENUE_CAT_API_KEY)
        
    }
    
    class AppDelegate: NSObject, UIApplicationDelegate {
     
        var ConversionData: [AnyHashable: Any]? = nil
         var window: UIWindow?
         var deferred_deep_link_processed_flag:Bool = false

         func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
             
             //  Set isDebug to true to see AppsFlyer debug logs
             AppsFlyerLib.shared().isDebug = false
             
             // Replace 'appsFlyerDevKey', `appleAppID` with your DevKey, Apple App ID
             AppsFlyerLib.shared().appsFlyerDevKey = Constants.AppsFlyer.APPS_FLYER_DEV_KEY
             AppsFlyerLib.shared().appleAppID = Constants.AppsFlyer.APPLE_APP_ID
             
             AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)

             // Subscribe to didBecomeActiveNotification if you use SceneDelegate or just call
             // -[AppsFlyerLib start] from -[AppDelegate applicationDidBecomeActive:]
             NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActiveNotification),
             // For Swift version < 4.2 replace name argument with the commented out code
             name: UIApplication.didBecomeActiveNotification, //.UIApplicationDidBecomeActive for Swift < 4.2
             object: nil)
             
             return true
         }
         
         @objc func didBecomeActiveNotification() {
             AppsFlyerLib.shared().start()
             if #available(iOS 14, *) {
               ATTrackingManager.requestTrackingAuthorization { (status) in
                 switch status {
                 case .denied:
                     print("AuthorizationSatus is denied")
                 case .notDetermined:
                     print("AuthorizationSatus is notDetermined")
                 case .restricted:
                     print("AuthorizationSatus is restricted")
                 case .authorized:
                     print("AuthorizationSatus is authorized")
                 @unknown default:
                     fatalError("Invalid authorization status")
                 }
               }
             }
         }
         
         // Open Universal Links
         
         // For Swift version < 4.2 replace function signature with the commented out code
         // func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool { // this line for Swift < 4.2
         func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
             AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
             return true
         }
                 
         // Open URI-scheme for iOS 9 and above
         func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
             AppsFlyerLib.shared().handleOpen(url, options: options)
             return true
         }
         
         // Report Push Notification attribution data for re-engagements
         func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
             AppsFlyerLib.shared().handlePushNotification(userInfo)
         }
         
     }


    
    
}
