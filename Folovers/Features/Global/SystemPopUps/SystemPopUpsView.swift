//
//  SystemPopUpsView.swift
//  Folovers
//
//  Created by user on 27.08.2026.
//

import SwiftUI

struct SystemPopUpsView: View {
  @Environment(NavigationManager.self) var navigation
  var body: some View {
	 ZStack{
		Group{
		  if let popUp = navigation.systemPopUps.last{
			 SystemPopUpView(popUp: popUp)
		  }
		}
		.transition(.move(edge: .top))
	 }
	 .frame(maxHeight: .infinity, alignment: .top)
	 .animation(.easeInOut, value: navigation.systemPopUps.count)
  }
}

#Preview {
  SystemPopUpsView()
	 .environment(NavigationManager.shared)
}
