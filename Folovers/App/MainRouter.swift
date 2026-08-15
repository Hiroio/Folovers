//
//  MainRouter.swift
//  Folovers
//
//  Created by user on 14.08.2026.
//

import SwiftUI

struct MainRouter: View {
  @Environment(NavigationManager.self) var navigationManager
    var body: some View {
		ZStack{
		  switch navigationManager.mainState{
		  case .home:
			 Text("Home")
		  case .folders:
			 FoldersView()
		  case .profile:
			 Text("Profile")
		  }
		  
		  CustomNavigationBar()
			 .padding(.bottom)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
}

#Preview {
    MainRouter()
	 .environment(NavigationManager.shared)
	 .environment(\.theme, .basic)
}
