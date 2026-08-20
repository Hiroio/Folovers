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
		VStack(){
		  ZStack{
			 switch navigationManager.mainState{
			 case .home:
				HomeView()
			 case .folders:
				FoldersView()
			 case .connections:
				ConnectionsView()
			 case .profile:
				ProfileView()
			 }
		  }
		  .frame(maxWidth: .infinity, maxHeight: .infinity)
		  
		  CustomNavigationBar()
		}
		.ignoresSafeArea(edges: .bottom)
		
    }
}

#Preview {
    MainScreens()
	 .environment(\.theme, .basic)
	 .environment(NavigationManager.shared)
}
