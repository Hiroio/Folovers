//
//  MainRouter.swift
//  Folovers
//
//  Created by user on 14.08.2026.
//

import SwiftUI

struct MainRouter: View {
  @Environment(\.theme) var theme
  @Environment(NavigationManager.self) var navigationManager
  
  init() {
	 let _ = FolderManager.shared
  }
  var body: some View {
	 ZStack(){
		theme.background.ignoresSafeArea()
		
		MainScreens()
		
		if let secondary = navigationManager.secondaryView.last{
		  SecondaryScreen(screen: secondary)
			 .transition(secondary.transition)
			 .zIndex(1)
			 .allowsHitTesting(!navigationManager.secondaryView.isEmpty)
		}
		
		if let _ = navigationManager.plan{
		  //		  TODO: PLAN CARD VIEW
		}
		
		
		ZStack{
		  if !navigationManager.popUps.isEmpty{
			 Color.black.ignoresSafeArea().opacity(0.4)
				.onTapGesture {
				  navigationManager.clearPopUps()
				}
		  }
		  if let popUp = navigationManager.popUps.last{
			 PopUpViews(popUp: popUp)
				.transition(.scale.combined(with: .opacity))
				.zIndex(2)
		  }
		}
		.zIndex(1)
		.allowsHitTesting(!navigationManager.popUps.isEmpty)
		
	 }
	 .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
	 .animation(.easeInOut, value: navigationManager.popUps.count)
  }
}

#Preview {
  MainRouter()
	 .environment(NavigationManager.shared)
	 .environment(\.theme, .basic)
}
