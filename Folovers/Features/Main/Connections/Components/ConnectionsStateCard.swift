//
//  ConnectionsStateCard.swift
//  Folovers
//
//  Created by user on 21.08.2026.
//

import SwiftUI

struct ConnectionsStateCard: View {
  let state: ConnectionsState
  @Environment(\.theme) var theme
  var body: some View {
	 VStack{
		VStack(){
		  Image(state.image)
			 .resizable()
			 .scaledToFit()
			 .containerRelativeFrame(.vertical, count: 4, spacing: 10)
			 .padding(.vertical)
			 .shadow(radius: 5, y: 8)
		  Text(state.text)
			 .font(.title2.weight(.bold))
			 .foregroundStyle(theme.primaryDark)
			 .multilineTextAlignment(.center)
			 .padding(.horizontal, 10)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.card(lineWidth: 4,dashed: true)
		.padding()
		.aspectRatio(1, contentMode: .fit)
		
		
		Button{}label:{
		  actionBtn(state: state)
		}
	 }
  }
}

#Preview {
  ConnectionsStateCard(state: .empty)
	 .environment(\.theme, .basic)
	 .fontDesign(.monospaced)
}


extension ConnectionsStateCard{
  @ViewBuilder
  func actionBtn(state: ConnectionsState) -> some View{
	 let error = state != .empty && state != .pendingEmpty
	 Text(state.actionBtn)
		.foregroundStyle(error ? .white : theme.primaryDark)
		.frame(maxWidth: .infinity)
		.padding()
		.background(
		  RoundedRectangle(cornerRadius: 15)
			 .fill(error ? theme.primary : theme.surface )
		)
		.border(lineWidth: error ? 0 : 2, dashed: true)
  }
}
