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
		.padding(3)
		.card()
		.aspectRatio(contentMode: .fit)
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
	 ZStack{
		let selected = navigationManager.mainState == item
		if selected{
		  ZStack{
			 RoundedRectangle(cornerRadius: 15)
				.fill(theme.primaryDark.opacity(0.5))
			 RoundedRectangle(cornerRadius: 15)
				.stroke(theme.primaryDark, lineWidth: 2)
		  }
		  .matchedGeometryEffect(id: "nav", in: navNamespace)
		}
		Image(systemName: item.icon)
		  .font(.headline.weight(.semibold))
		  .padding(10)
		  .foregroundStyle(selected ? theme.background : theme.primaryDark)
		
	 }
	 .padding(.horizontal, 20)
	 .containerRelativeFrame(.horizontal, count: 3, spacing: 30)
  }
}
