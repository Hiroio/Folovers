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
  
  init(){
	 FirebaseApp.configure()
  }
    var body: some Scene {
        WindowGroup {
			 LoadingView()
        }
    }
}
