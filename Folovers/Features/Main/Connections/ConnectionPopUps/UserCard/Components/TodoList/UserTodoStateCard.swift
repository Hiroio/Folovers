//
//  UserTodoStateCard.swift
//  Folovers
//
//  Created by user on 01.10.2026.
//

import SwiftUI

struct UserTodoStateCard: View {
  @Environment(\.theme) var theme
  let state: UserTodoListState
	 var body: some View {
		VStack(spacing: 15){
		  Image(systemName: state.icon)
			 .font(.largeTitle)
		  Text(state.text)
			 .font(.headline.weight(.bold))
			 .multilineTextAlignment(.center)
		}
		.foregroundStyle(theme.primaryDark)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.card()
		.fontDesign(.monospaced)
	 }
}

#Preview {
  VStack(spacing: 20){
	 UserTodoStateCard(state: .empty)
	 UserTodoStateCard(state: .closed)
  }
  .padding()
  .environment(\.theme, .basic)
}
