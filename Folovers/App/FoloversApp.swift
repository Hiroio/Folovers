//
//  FoloversApp.swift
//  Folovers
//
//  Created by user on 10.08.2026.
//

import SwiftUI

@main
struct FoloversApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  @State private var themeManager = ThemeManager.shared

    var body: some Scene {
        WindowGroup {
			 AppRoute()
				.environment(\.theme, themeManager.palette)
        }
    }
}
