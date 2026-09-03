//
//  ConfirmationPopUp.swift
//  Folovers
//
//  Created by user on 03.09.2026.
//

import SwiftUI

struct ConfirmationPopUp: View {
  @Environment(\.theme) var theme
  let model: ConfirmationPopUpModel

  var body: some View {
	 VStack(spacing: 20){
		Text(model.text)
		  .font(.headline.weight(.medium))
		  .multilineTextAlignment(.center)
		  .foregroundStyle(theme.text)

		HStack(spacing: 15){
		  Button{
			 NavigationManager.shared.popPopUp()
		  }label:{
			 Text("Cancel")
				.frame(maxWidth: .infinity)
				.foregroundStyle(theme.primaryDark)
				.padding(12)
				.card(12)
				.compositingGroup()
		  }
		  .buttonStyle(CustomAnimationForBtn(light: true))

		  Button{
			 model.onConfirm()
			 NavigationManager.shared.popPopUp()
		  }label:{
			 Text(model.confirmText)
				.frame(maxWidth: .infinity)
				.foregroundStyle(.white)
				.padding(12)
				.background(
				  RoundedRectangle(cornerRadius: 15)
					 .fill(model.isDestructive ? .red : theme.primary)
				)
				.compositingGroup()
		  }
		  .buttonStyle(CustomAnimationForBtn(light: false))
		}
	 }
	 .padding()
	 .card(15, lineWidth: 3)
	 .padding(.horizontal, 40)
	 .compositingGroup()
	 .fontDesign(.monospaced)
  }
}

#Preview {
  ConfirmationPopUp(model: .init(text: "Delete this todo?", onConfirm: {}))
	 .environment(\.theme, .basic)
}
