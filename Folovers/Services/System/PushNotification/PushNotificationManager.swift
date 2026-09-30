//
//  PushNotificationManager.swift
//  Folovers
//
//  Created by user on 29.09.2026.
//

import Foundation
import UIKit
import UserNotifications
import FirebaseMessaging

//  NSObject - MessagingDelegate/UNUserNotificationCenterDelegate are Obj-C protocols
@Observable
final class PushNotificationManager: NSObject{
  static let shared = PushNotificationManager()

  var isAuthorized: Bool = false
//  Kept here regardless of whether a user is signed in yet - it can arrive
//  before login, and login/createUserDocument re-check it once they're ready
  private(set) var fcmToken: String? = nil

  private let userManager = UserManager.shared

  override init(){
	 super.init()
	 Messaging.messaging().delegate = self
	 UNUserNotificationCenter.current().delegate = self
  }
}

extension PushNotificationManager{
  func requestAuthorization(){
	 Task{
		do{
		  isAuthorized = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
		}catch{
		  isAuthorized = false
		}

		guard isAuthorized else { return }
		UIApplication.shared.registerForRemoteNotifications()
	 }
  }

//  Writes fcmToken into the current user if both are present and it isn't
//  already saved. Call this whenever either side of that pair changes -
//  a fresh token, a login, or a just-created user document
  func syncTokenIfNeeded(){
	 Task{
		guard let fcmToken, var user = userManager.currentUser, user.fcmToken != fcmToken else { return }
		user.fcmToken = fcmToken
		if await userManager.updateUser(user: user){
		  print(user)
		  print("User Updated")
		}
	 }
  }

//  The device keeps its token in fcmToken above
  func clearToken(){
	 Task{
		guard var user = userManager.currentUser, user.fcmToken != nil else { return }
		user.fcmToken = nil
		_ = await userManager.updateUser(user: user)
	 }
  }
}

extension PushNotificationManager: MessagingDelegate{
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
	 guard let fcmToken else { return }
	 self.fcmToken = fcmToken
	 print(fcmToken)
	 syncTokenIfNeeded()
  }
}

extension PushNotificationManager: UNUserNotificationCenterDelegate{
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions{
	 [.banner, .sound, .badge]
  }
}
