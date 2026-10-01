//
//  AccountLinks.swift
//  Folovers
//
//  Created by user on 01.10.2026.
//

import SwiftUI
import AuthLibrary

struct AccountLinks: View {
  @Environment(\.theme) var theme
  @State private var accountExpanded: Bool = false
    var body: some View {
		VStack{
		  Button{
			 withAnimation{
				accountExpanded.toggle()
			 }
		  }label:{
			 HStack{
				LinkRow(.account)
				Image(systemName: "chevron.right")
				  .foregroundStyle(theme.secondaryText)
				  .rotationEffect(.degrees(accountExpanded ? 90 : 0))
			 }
			 .contentShape(.rect)
		  }
		  
		  if accountExpanded{
			 VStack(spacing: 15){
				passwordBtn
				providerRow(.apple)
				providerRow(.google)
			 }
			 .padding(.horizontal)
			 .padding(.bottom, 10)
		  }
		}
    }
}

#Preview {
    AccountLinks()
	 .environment(\.theme, .basic)
}


extension AccountLinks{
  @ViewBuilder
  func providerRow(_ provider: AuthUserType) -> some View{
	 let isLinked = AuthManager.shared.currentUser?.types.contains(provider) ?? false
	 
	 HStack{
		
		if isLinked{
		  HStack{
			 Image(systemName: provider == .apple ? "applelogo" : "g.square")
				.font(.headline.weight(.semibold))
			 Text("Linked")
				.font(.headline)
			 Spacer()
			 Image(systemName: "checkmark")
				.font(.headline)
		  }
		  .frame(maxWidth: .infinity, alignment: .leading)
		  .card(13)
		}else if provider == .apple{
		  AppleSignBtn(mode: .link, action: AuthManager.shared.linkSSO)
			 .frame(height: 55)
		}else{
		  GoogleSignBtn(mode: .link, action: AuthManager.shared.linkSSO)
			 .frame(height: 55)
		}
	 }
  }
  
  
  private var passwordBtn: some View{
	 Button{
		AuthManager.shared.resetPassword()
	 }label:{
		HStack{
		  Image(systemName: "lock")
		  Text("Reset password")
		}
		.frame(maxWidth: .infinity)
		.card(13)
	 }
  }
}
