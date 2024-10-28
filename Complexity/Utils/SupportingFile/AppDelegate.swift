//
//  AppDelegate.swift
//  Complexity
//
//  Created by IE12 on 25/04/24.
//

import Foundation
import UIKit
import GooglePlaces
import GoogleMaps
import IQKeyboardManagerSwift
import IQAPIClient
import GoogleSignIn
import SwiftUI
import Firebase
import KeychainSwift
import FirebaseCore
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        IQKeyboardManager.shared.enable = true
        IQAPIClient.configureAPIClient()
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            window.makeKeyAndVisible()
            self.window = window
        }
        
        GMSServices.provideAPIKey(StringConstants.GoogleAPIKey.key)
        GMSPlacesClient.provideAPIKey(StringConstants.GoogleAPIKey.key)
        IQKeyboardManager.shared.enable = true
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
        return true
        
    }
    
    func application(
        _ app: UIApplication,
        open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        
        return false
    }
    
    func setWindowGroup(_ view: AnyView) {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: view)
        }
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let deviceToken: [String: String] = ["token": fcmToken ?? ""]
        if let token = deviceToken["token"] {
            print("Fcm token: ", token)
            KeychainManager.token = token
        } else {
            print("No device token available")
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      let userInfo = notification.request.content.userInfo

      if let messageID = userInfo[gcmMessageIDKey] {
      }

      completionHandler([[.banner, .badge, .sound]])
    }

      func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
          let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
      }

      func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

      }

      func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  didReceive response: UNNotificationResponse,
                                  withCompletionHandler completionHandler: @escaping () -> Void) {
          let userInfo = response.notification.request.content.userInfo
    
              let scenes = UIApplication.shared.connectedScenes
              let windowScene = scenes.first as? UIWindowScene
              windowScene?.windows.forEach  { window in
                  window.rootViewController?.dismiss(animated: false, completion: nil)
              }
          completionHandler()
      }
      
      
  }
