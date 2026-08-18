//
//  MainRouter.swift
//  Folovers
//
//  Created by user on 14.08.2026.
//

import SwiftUI

struct MainRouter: View {
  @Environment(NavigationManager.self) var navigationManager
  
  init() {
	 let _ = FolderManager.shared
  }
  var body: some View {
	 ZStack(){
		MainScreens()
		
		if let secondary = navigationManager.secondaryView.last{
		  SecondaryScreen(screen: secondary)
			 .transition(secondary.transition)
			 .zIndex(1)
			 .allowsHitTesting(!navigationManager.secondaryView.isEmpty)
		}
		
		if let plan = navigationManager.plan{
		  
		}

		if let third = navigationManager.thirdScreen{
		  ThirdScreen(screen: third)
			 .transition(third.transition)
			 .zIndex(2)
		}
	 }
	 .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
  }
}

#Preview {
  MainRouter()
	 .environment(NavigationManager.shared)
	 .environment(\.theme, .basic)
}
