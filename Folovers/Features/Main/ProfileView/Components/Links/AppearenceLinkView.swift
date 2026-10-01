//
//  AppearenceLinkView.swift
//  Folovers
//
//  Created by user on 01.10.2026.
//

import SwiftUI

struct AppearenceLinkView: View {
  @Environment(\.theme) var theme
  @State private var appearenceExpanded: Bool = false
  
    var body: some View {
		VStack{
		  Button{
			 withAnimation(){
				appearenceExpanded.toggle()
			 }
		  }label: {
			 HStack{
				LinkRow(.appearence)
				Image(systemName: "chevron.right")
				  .foregroundStyle(theme.secondaryText)
				  .rotationEffect(.degrees(appearenceExpanded ? 90 : 0))
			 }
			 .contentShape(.rect)
		  }
		  
		  if appearenceExpanded{
			 ColorSelectionBar(color: Binding(get: {
				ThemeManager.shared.selectedColor
			 }, set: { color in
				withAnimation {
				  ThemeManager.shared.selectedColor = color
				}
			 }))
			 .padding(.horizontal)
			 .transition(.opacity.combined(with: .scale(0.2, anchor: .topLeading)))
		  }
		}
    }
}

#Preview {
    AppearenceLinkView()
	 .environment(\.theme, .basic)
}
