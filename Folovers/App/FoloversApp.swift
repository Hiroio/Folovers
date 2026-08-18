//
//  FoloversApp.swift
//  Folovers
//
//  Created by user on 10.08.2026.
//

import SwiftUI
import FirebaseCore

@main
struct FoloversApp: App {
  @State private var themeManager = ThemeManager.shared
  @State private var navigationManager = NavigationManager.shared
  init(){
	 
	 FirebaseApp.configure()
  }
    var body: some Scene {
        WindowGroup {
			 MainRouter()
				.environment(\.theme, themeManager.palette)
				.environment(navigationManager)
        }
    }
}
