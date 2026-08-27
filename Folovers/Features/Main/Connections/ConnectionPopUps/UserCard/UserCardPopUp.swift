//
//  UserCardPopUp.swift
//  Folovers
//
//  Created by user on 22.08.2026.
//

import SwiftUI

struct UserCardPopUp: View {
  @Environment(\.theme) var theme
  @State private var vm: UserCardViewModel

  init(uid: String, user: UserDocument?){
	 self._vm = State(wrappedValue: UserCardViewModel(uid: uid, user: user))
  }

	 var body: some View {
		let user = vm.user ?? .placeholder(id: vm.uid)

		VStack(spacing: 15){
		  Button{
			 NavigationManager.shared.popPopUp()
		  }label: {
			 Image(systemName: "xmark")
				.font(.headline.weight(.semibold))
				.foregroundStyle(theme.primaryDark)
				.padding(5)
		  }
		  .frame(maxWidth: .infinity,alignment: .trailing)

		  VStack(spacing: 25){
			 SpriteView(action: .idle, config: user.characterConfig)
				.frame(maxWidth: .infinity)
				.padding()
				.border(lineWidth: 2)
				.padding(.horizontal)

			 Text(user.displayName)
				.font(.title2.weight(.bold))
				.redacted(reason: vm.user == nil ? .placeholder : [])

			 if let user = vm.user{
				Text("Joined: \(user.createdAt.formatted(.dateTime.day(.defaultDigits).month(.abbreviated).year()))")
				  .foregroundStyle(theme.secondaryText)
			 }

			 VStack(spacing: 8){
				actionSection

				if let errorText = vm.errorText{
				  HStack(spacing: 5){
					 Image(systemName: "exclamationmark.circle")
					 Text(errorText)
				  }
				  .font(.caption)
				  .foregroundStyle(.red)
				  .transition(.move(edge: .top).combined(with: .opacity))
				}
			 }
			 .animation(.easeInOut, value: vm.errorText)
		  }
		  .padding(10)
		}
		.fontDesign(.monospaced)
		.card(15, lineWidth: 5, dashed: true)
		.padding()
		.task{
		  await vm.loadUser()
		}
    }
}

#Preview {
  UserCardPopUp(uid: "qwerqwe", user: nil)
	 .environment(\.theme, .basic)
}


extension UserCardPopUp{
  @ViewBuilder
  var actionSection: some View{
	 switch vm.btnStatus {
	 case .none:
		Button{
		  vm.sendConnectionRequest()
		}label: {
		  Text("Send Request")
			 .foregroundStyle(theme.primaryDark)
			 .border(15, dashed: true)
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
		Text("Already connected")
		  .font(.headline.weight(.semibold))
		  .foregroundStyle(theme.primaryDark)
		  .border(15)
	 }
  }
}
