//
//  AppDelegate.swift
//  Folovers
//
//  Created by user on 29.09.2026.
//

import UIKit
import FirebaseCore
import FirebaseMessaging

//  Firebase needs to be configured here, not in FoloversApp.init(), so it is
//  guaranteed ready before anything (PushNotificationManager included) touches it
final class AppDelegate: NSObject, UIApplicationDelegate{
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
	 FirebaseApp.configure()

//	 Forces the delegates (MessagingDelegate, UNUserNotificationCenterDelegate)
//	 to be wired from launch, independent of when requestAuthorization() runs
	 _ = PushNotificationManager.shared

	 return true
  }

  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
	 Messaging.messaging().apnsToken = deviceToken
  }

  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
	 print("DEBUG: Failed to register for remote notifications: \(error.localizedDescription)")
  }
}
