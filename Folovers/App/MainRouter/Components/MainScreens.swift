//
//  MainScreens.swift
//  Folovers
//
//  Created by user on 17.08.2026.
//

import SwiftUI

struct MainScreens: View {
  @Environment(NavigationManager.self) var navigationManager
    var body: some View {
		ZStack{
		  switch navigationManager.mainState{
		  case .home:
			 Text("Home")
		  case .folders:
			 FoldersView()
		  case .profile:
			 ProfileView()
		  }
		}
		.safeAreaInset(edge: .bottom, content: {
		  CustomNavigationBar()
			 .padding(.bottom)
		})
    }
}

#Preview {
    MainScreens()
}
