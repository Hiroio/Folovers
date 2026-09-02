//
//  UserCardView.swift
//  Folovers
//
//  Created by user on 02.09.2026.
//

import SwiftUI

struct UserCardView: View {
  @Environment(\.theme) var theme
  @Bindable var vm: UserCardViewModel
  var body: some View {
	 let user = vm.user ?? .placeholder(id: vm.uid)
	 VStack(spacing: 25){
		VStack{
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
		}
		.frame(maxHeight: .infinity, alignment: .top)
		
		VStack(spacing: 8){
		  UserPopUpButton(vm: vm)
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
		.zIndex(-1)
		.padding(10)
	 }
  }
}

#Preview {
  UserCardView(vm: .init(uid: ""))
	 .environment(\.theme, .basic)
}

