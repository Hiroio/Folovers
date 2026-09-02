//
//  UserSegmentedPicker.swift
//  Folovers
//
//  Created by user on 02.09.2026.
//

import SwiftUI

struct UserSegmentedPicker: View {
  @Environment(\.theme) var theme
  @Binding var state: UserPopUpState
    var body: some View {
		HStack(spacing: 15){
		  ForEach(UserPopUpState.allCases, id: \.self){item in
			 let active = item == state
			 Button{
				withAnimation(.easeInOut(duration: 0.6)){
				  state = item
				}
			 }label:{
				Text(item.rawValue.capitalized)
				  .foregroundStyle(active ? theme.primary : theme.secondaryText)
				  .scaleEffect(active ? 1.1 : 0.9)
				  
			 }
			 
			 if item != .plan{
				Text("/")
				  
			 }
		  }
		}
		.padding(.horizontal)
		.card(10)
    }
}

#Preview {
  @Previewable @State var test: UserPopUpState = .user
  UserSegmentedPicker(state: $test)
	 .environment(\.theme, .basic)
	 .fontDesign(.monospaced)
}
