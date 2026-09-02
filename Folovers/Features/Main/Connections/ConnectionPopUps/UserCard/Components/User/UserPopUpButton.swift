//
//  UserPopUpButton.swift
//  Folovers
//
//  Created by user on 02.09.2026.
//

import SwiftUI

struct UserPopUpButton: View {
  @Environment(\.theme) var theme
  @Bindable var vm: UserCardViewModel
    var body: some View {
		switch vm.btnStatus {
	 case .none:
		Button{
		  vm.sendConnectionRequest()
		}label: {
		  Text("Send Request")
			 .foregroundStyle(theme.primaryDark)
			 .border(15)
		}
		.disabled(vm.loading)

	 case .incoming:
		VStack(spacing: 15){
		  HStack(spacing: 15){
			 Button{
				vm.deleteConnection()
			 }label: {
				Text("Decline")
				  .frame(maxWidth: .infinity)
				  .padding()
				  .border(dashed: true)
			 }

			 Button{
				vm.acceptRequest()
			 }label:{
				Text("Accept")
				  .frame(maxWidth: .infinity)
				  .padding()
				  .border(dashed: true)
			 }
		  }
		  .foregroundStyle(theme.primaryDark)
		  .padding(.horizontal)
		  .disabled(vm.loading)

		  Text("User waiting for your answer")
			 .font(.caption)
			 .foregroundStyle(theme.secondaryText)
		}

	 case .outgoing:
		VStack(spacing: 15){
		  Text("Pending")
			 .foregroundStyle(theme.secondaryText)
			 .frame(maxWidth: .infinity)
			 .border(15, dashed: true)

		  Button{
			 vm.deleteConnection()
		  }label: {
			 Text("Cancel request")
				.font(.caption)
				.foregroundStyle(theme.secondaryText)
		  }
		  .disabled(vm.loading)
		}

	 case .connected:
		Button{
		  if let userId = vm.user?.id{
			 NavigationManager.shared.addPopUp(.letterCreation(to: userId))
		  }
		}label:{
		  Text("Send a letter")
			 .foregroundStyle(theme.primary)
			 .card(15, lineWidth: 2)
			 .compositingGroup()
		}
		.buttonStyle(CustomAnimationForBtn(light: false))
	 }
  }
}

#Preview {
  UserPopUpButton(vm: .init(uid: ""))
	 .environment(\.theme, .basic)
}
