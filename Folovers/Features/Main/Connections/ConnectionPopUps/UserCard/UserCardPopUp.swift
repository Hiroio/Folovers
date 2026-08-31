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

		ZStack{
		  VStack(spacing: 15){
			 Header
			 
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
					 .onAppear{
						Task{
						  try? await Task.sleep(for: .seconds(1.5))
						  vm.errorText = nil
						}
					 }
				  }
				}
				.animation(.easeInOut, value: vm.errorText)
			 }
			 .zIndex(-1)
			 .padding(10)
		  }
			 Color.black.opacity(0.0001)
				.scaledToFit()
				.onTapGesture {
				  vm.menuIsActive = false
				}
				.zIndex(-1)
				.allowsHitTesting(vm.menuIsActive)
		  
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
  
  
  private var Header: some View{
	 HStack{
		Button{
		  NavigationManager.shared.popPopUp()
		}label: {
		  Image(systemName: "xmark")
			 .foregroundStyle(theme.primaryDark)
			 .padding(5)
		}
		Spacer()
		
		Button{
		  withAnimation{
			 vm.menuIsActive = true
		  }
		}label:{
		  Image(systemName: "ellipsis")
			 .foregroundStyle(theme.primaryDark)
		}
		.overlay(alignment: .topTrailing){
		  MenuSection
			 .fixedSize()
			 .zIndex(2)
			 .scaleEffect(vm.menuIsActive ? 1.1 : 0, anchor: .topTrailing)
			 .allowsHitTesting(vm.menuIsActive)
		}
		.opacity(vm.btnStatus == .connected ? 1 : 0)
	 }
	 .font(.title2)
	 .frame(maxWidth: .infinity, alignment: .trailing)
  }
  
  private var MenuSection: some View{
	 VStack(alignment: .leading, spacing: 15){
		Button{
		  withAnimation{
			 vm.goToFolder()
		  }
		}label:{
		  HStack{
			 Text("Go to Folder")
			 Image(systemName: "folder")
		  }
		}
		.disabled(vm.sharedFolder == nil)
		.opacity(vm.sharedFolder == nil ? 0.4 : 1)
		
		Divider()
		
		Button{
		  withAnimation{
			 vm.createFolder()
		  }
		}label:{
		  HStack{
			 Text("Create Folder")
			Image(systemName: "plus.app")
		  }
		}
		.disabled(vm.sharedFolder != nil)
		.opacity(vm.sharedFolder != nil ? 0.4 : 1)
		
		Divider()
		
		Button{
		  vm.deleteConnection()
		}label:{
		  HStack{
			 Text("Remove")
			 Image(systemName: "trash")
		  }
		}
	 }
	 .card(10)
	 .font(.footnote)
	 .foregroundStyle(theme.primaryDark)
	 .zIndex(1)
  }
}



