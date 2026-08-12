//
//  NavigationManager.swift
//  Folovers
//
//  Created by user on 12.08.2026.
//

import Foundation


@MainActor
@Observable
final class NavigationManager {
  static let shared = NavigationManager()
  
  var startLoading: Bool = false
  
  var state: StartNavigationFlow {
	 guard startLoading else { return .longLoading}
	 guard AuthManager.shared.currentUser != nil else { return .unauthenticated }
	 guard UserManager.shared.isInitialized else { return .shortLoading }
	 guard UserManager.shared.currentUser != nil else { return .needsOnboarding }
	 return .ready
  }
  
  init(){
  }
}
