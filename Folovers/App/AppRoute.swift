//
//  AppRoute.swift
//  Folovers
//
//  Created by user on 12.08.2026.
//

import SwiftUI

struct AppRoute: View {
  @State private var navigation: NavigationManager = .shared
  var body: some View {
	 ZStack{
		switch navigation.state {
		case .longLoading:
		  LoadingView(state: .longLoading)
			 .zIndex(1)
			 .allowsHitTesting(false)
			 .transition(.opacity)
		case .shortLoading:
		  LoadingView(state: .longLoading)
			 .zIndex(1)
			 .allowsHitTesting(false)
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
	 .environment(navigation)
  }
}

#Preview {
    AppRoute()
}
