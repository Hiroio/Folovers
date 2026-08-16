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
  init(){
	 
	 FirebaseApp.configure()
  }
    var body: some Scene {
        WindowGroup {
			 ZStack {
				ThemePalette.basic.background.ignoresSafeArea()
				PlansSliderView(plans: PlanCard.plans(), state: .plans)
				  .padding()
			 }
			 .environment(\.theme, themeManager.palette)
        }
    }
}
