//
//  NotificationManager.swift
//  Complexity
//
//  Created by IE Mac 05 on 06/06/24.

import Foundation
import UserNotifications
import SwiftUI
import Firebase
import FirebaseMessaging

@MainActor
class NotificationManager: NSObject, ObservableObject, MessagingDelegate {
    @Published private(set) var hasPermission = false
    let gcmMessageIDKey = "gcm.message_id"

    func request() async {
        do {
            try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            await getAuthStatus()
        } catch {
            print(error)
        }
    }

    func getAuthStatus() async {
        let status = await UNUserNotificationCenter.current().notificationSettings()
        switch status.authorizationStatus {
        case .authorized, .ephemeral, .provisional:
            requestAuthorization()
        default:
            requestAuthorization()
        }
    }

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Request Authorization Failed: \(error.localizedDescription)")
            }
            if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                        if let token = Messaging.messaging().fcmToken {
                            print(token)
                            KeychainManager.token = token
                        }
                    }
                
            } else {
                print("Notification Permission Denied.")
            }
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken = fcmToken {
            print("Received FCM registration token:", fcmToken)
            KeychainManager.token = fcmToken
        } else {
            print("Failed to receive FCM registration token")
        }
    }

}
extension NotificationManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      let userInfo = notification.request.content.userInfo

      if let messageID = userInfo[gcmMessageIDKey] {
      }

      completionHandler([[.banner, .badge, .sound]])
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
