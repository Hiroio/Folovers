//
//  UserCardPopUp.swift
//  Folovers
//
//  Created by user on 22.08.2026.
//

import SwiftUI

struct UserCardPopUp: View {
  @Environment(\.theme) var theme
  let user: UserDocument
  let connection: ConnectionModel?
    var body: some View {
		VStack(spacing: 15){
		  Button{
			 
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
			 
				Text("Joined: \(user.createdAt.formatted(.dateTime.day(.defaultDigits).month(.abbreviated).year()))")
				.foregroundStyle(theme.secondaryText)
				
			 
			 if let connection{
				if connection.status == .pending{
				  pendingButton(connection: connection)
					 .padding(.horizontal)
				}else{
				  Text("Already connected")
					 .font(.headline.weight(.semibold))
					 .foregroundStyle(theme.primaryDark)
					 .border(15)
				}
			 }else{
				Button{
				  
				}label: {
				  Text("Send Request")
					 .foregroundStyle(theme.primaryDark)
					 .border(15, dashed: true)
				}
			 }
		  }
		  .padding(10)
		}
		.fontDesign(.monospaced)
		.card(15, lineWidth: 5, dashed: true)
		.padding()
    }
}

#Preview {
  UserCardPopUp(user: .placeholder(id: "qwerqwe"), connection: .conncetion(id: "qweqweqw"))
	 .environment(\.theme, .basic)
}


extension UserCardPopUp{
  @ViewBuilder
  func pendingButton(connection: ConnectionModel) -> some View{
	 if connection.requestedBy == AuthManager.shared.id{
		Text("Pending")
		  .foregroundStyle(theme.secondaryText)
		  .frame(maxWidth: .infinity)
		  .border(15, dashed: true)
	 }else{
		VStack(spacing: 15){
		  HStack{
			 Button{}label: {
				Text("Decline")
			 }
			 
			 Button{}label:{
				Text("Accept")
				  .frame(maxWidth: .infinity)
				  .padding()
				  .border(dashed: true)
			 }
		  }
		  Text("User waiting for your answer")
			 .font(.caption)
			 .foregroundStyle(theme.secondaryText)
		}
	 }
  }
}
