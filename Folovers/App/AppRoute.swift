//
//  AppRoute.swift
//  Folovers
//
//  Created by user on 12.08.2026.
//

import SwiftUI

struct AppRoute: View {
  @Environment(\.theme) var theme
  @State private var navigation: NavigationManager = .shared
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
		  Text("OnBoarding")
		  
		case .ready:
		  Text("MainApp")
		}
	 }
	 .animation(.easeInOut(duration: 0.8), value: navigation.state)
	 .animation(.easeInOut(duration: 0.5), value: theme.background)
	 .environment(navigation)
  }
}

#Preview {
    AppRoute()
	 .environment(\.theme, .basic)
}
