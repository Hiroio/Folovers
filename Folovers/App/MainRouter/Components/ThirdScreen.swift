//
//  ThirdScreen.swift
//  Folovers
//
//  Created by user on 17.08.2026.
//

import SwiftUI

struct ThirdScreen: View {
  let screen: ThirdTypeScreenEnum
  @Environment(\.theme) var theme
	 var body: some View {
		  ZStack{
			 theme.background.ignoresSafeArea()
			 switch screen {
			 case .plan(let plan):
				VStack{
				  Button{
					 NavigationManager.shared.thirdScreen = nil
				  }label:{
					 Text("Back!")
				  }
				  .padding(.vertical)
				  Text(plan.title)
					 .transition(screen.transition)
				}
				.frame(maxWidth: .infinity)
				.background(theme.background)
			 }
		  }
		  .animation(.easeInOut, value: screen.id)
	 }
}

#Preview {
  ThirdScreen(screen: .plan(plan: .init(folderId: "", createdBy: "")))
}
