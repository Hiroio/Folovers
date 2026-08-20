//
//  CustomNavigationBar.swift
//  Folovers
//
//  Created by user on 14.08.2026.
//

import SwiftUI

struct CustomNavigationBar: View {
  @Namespace var navNamespace
  @Environment(\.theme) var theme
  @Environment(NavigationManager.self) var navigationManager
    var body: some View {
		HStack{
		  ForEach(MainNavigationFlow.allCases){item in
			 Button{
				withAnimation {
				  navigationManager.mainState = item
				}
			 }label: {
				BarItem(item: item)
			 }
		  }
		}
		.padding(15)
		.padding(.bottom)
		.background(
		  UnevenRoundedRectangle(cornerRadii: .init(topLeading: 15, bottomLeading: 0, bottomTrailing: 0, topTrailing: 15))
			 .fill(theme.background)
			 .shadow(radius: 5, y: -3)
		)
    }
}

#Preview {
    CustomNavigationBar()
	 .environment(NavigationManager.shared)
	 .environment(\.theme, .basic)
}


extension CustomNavigationBar{
  @ViewBuilder
  func BarItem(item: MainNavigationFlow) -> some View{
	 ZStack(alignment: .bottom){
		let selected = navigationManager.mainState == item
		if selected{
		  ZStack{
			 RoundedRectangle(cornerRadius: 15)
				.fill(theme.primaryDark.opacity(0.5))
				.frame(height: 5)
				.padding(.horizontal)
				.shadow(color: theme.primary, radius: 5, y: -3)
		  }
		  .matchedGeometryEffect(id: "nav", in: navNamespace)
		}
		Image(systemName: "\(item.icon)\(selected ? ".fill" : "")")
		  .font(.headline.weight(.semibold))
		  .padding(10)
		  .foregroundStyle(theme.primaryDark)
		
	 }
	 .frame(maxWidth: .infinity)
  }
}
