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
  var secondaryView: [SecondaryViewsEnum] = []
  var plan: PlanCard? = nil
  var popUps: [NavigationPopUp] = []
  var systemPopUps: [SystemPopUpModel] = []

  @ObservationIgnored
  private var dismissTask: Task<Void, Never>? = nil

  @ObservationIgnored
  private let systemPopUpDuration: Duration = .seconds(2.5)
  
  var state: StartNavigationFlow {
	 guard startLoading else { return .longLoading}
	 guard AuthManager.shared.currentUser != nil else { return .unauthenticated }
	 guard UserManager.shared.isInitialized else { return .shortLoading }
	 guard UserManager.shared.currentUser != nil else { return .needsOnboarding }
	 return .ready
  }
  
  
  var mainState: MainNavigationFlow = .home
  
  init(){
  }
}


extension NavigationManager{
  func addSecondary(_ type: SecondaryViewsEnum){
	 self.secondaryView.append(type)
  }
  
  func popSecondary() {
	 let _ = self.secondaryView.popLast()
  }
}

// MARK: ------Pop Ups--------
extension NavigationManager{

  func addPopUp(_ destination: NavigationPopUp){
	 self.popUps.append(destination)
  }
  
  func popPopUp(){
	 let _ = self.popUps.popLast()
  }
  
  func clearPopUps(){
	 self.popUps = []
  }

  func confirm(_ text: String, confirmText: String = "Delete", isDestructive: Bool = true, onConfirm: @escaping () -> Void){
	 addPopUp(.confirmation(.init(text: text, confirmText: confirmText, isDestructive: isDestructive, onConfirm: onConfirm)))
  }
}


// MARK: ------System Pop Ups--------
extension NavigationManager{
  func popSystemUp(){
	 let _ = self.systemPopUps.popLast()
  }

  func addSystemUp(_ popUp: SystemPopUpModel){
//	 The same message twice in a row is noise, not information
	 guard !systemPopUps.contains(where: { $0.text == popUp.text && $0.type == popUp.type }) else { return }

	 self.systemPopUps.insert(popUp, at: 0)
	 startDismissLoop()
  }

//  One timer for the whole queue. Each popup gets its full time on screen,
//  instead of every popup starting its own timer at once
  private func startDismissLoop(){
	 guard dismissTask == nil else { return }

	 dismissTask = Task{
		while !systemPopUps.isEmpty{
		  try? await Task.sleep(for: systemPopUpDuration)
		  guard !Task.isCancelled else { break }
		  popSystemUp()
		}
		dismissTask = nil
	 }
  }

  func clearSystemUps(){
	 dismissTask?.cancel()
	 dismissTask = nil
	 systemPopUps = []
  }
}

