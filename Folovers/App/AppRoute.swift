//
//  AppRoute.swift
//  Folovers
//
//  Created by user on 12.08.2026.
//

import SwiftUI

struct AppRoute: View {
  @Environment(\.theme) var theme
  @State private var authManager = AuthManager.shared
  @State private var navigation = NavigationManager.shared
  var body: some View {
	 ZStack{
		theme.background.ignoresSafeArea()
		switch navigation.state {
		case .longLoading:
		  LoadingView(state: .longLoading)
			 .zIndex(1)
			 .allowsHitTesting(false)
			 .transition(.opacity)
		case .shortLoading:
		  LoadingView(state: .shortLoading)
			 .zIndex(1)
			 .allowsHitTesting(true)
			 .transition(.opacity)
		case .unauthenticated:
		  AuthView()
			 .transition(.move(edge: .bottom).combined(with: .opacity))
		case .needsOnboarding:
		  CharacterAppearanceView()
		case .ready:
		  MainRouter()
		}
	 }
	 .animation(.easeInOut(duration: 0.8), value: navigation.state)
	 .animation(.easeInOut(duration: 0.5), value: theme.background)
	 .environment(authManager)
	 .environment(navigation)
	 .onChange(of: navigation.state){ _, newValue in
//		Fires post-onboarding for a new user, or post-login for a returning
//		one on a device that hasn't been asked yet. iOS won't re-prompt
//		once the user has already answered
		if newValue == .ready{
		  PushNotificationManager.shared.requestAuthorization()
		}
	 }
  }
}

#Preview {
    AppRoute()
	 .environment(\.theme, .basic)
}
