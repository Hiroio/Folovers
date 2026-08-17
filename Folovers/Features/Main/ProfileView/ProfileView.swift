//
//  ProfileView.swift
//  Folovers
//
//  Created by user on 14.08.2026.
//

import SwiftUI

struct ProfileView: View {
  @Namespace var profileNameSpace
  @Environment(\.theme) var theme
  @State private var vm = ProfileViewModel()
  var body: some View {
	 ZStack{
		VStack(spacing: 15){
		  profileHeader
		  
		  CharacterCardView(profileNameSpace: profileNameSpace)
		  
		  ProfileLinks()
			 .frame(maxHeight: .infinity, alignment: .top)
		}
		.padding()
		
		if vm.showConnectPopUp{
		  ZStack{
			 Color.black.opacity(0.3).ignoresSafeArea()
				.onTapGesture {
				  withAnimation {
					 vm.showConnectPopUp = false
				  }
				}
			 
			 ProfileConnectView(nameSpace: profileNameSpace)
				.padding()
		  }
		}
	 }
	 .fontDesign(.monospaced)
	 .environment(vm)
  }
}

#Preview {
  ZStack{
	 ThemePalette.basic.background.ignoresSafeArea()
	 ProfileView()
		.environment(\.theme, .basic)
  }
}


extension ProfileView{
  private var profileHeader: some View{
	 HStack{
		VStack(alignment: .leading){
		  Text("Profile")
			 .font(.title2)
			 .foregroundStyle(theme.text)
		  Text("your account and settings")
			 .font(.caption)
			 .foregroundStyle(theme.secondaryText)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		
		Button{
		  withAnimation(.easeInOut(duration: 0.4)){
			 vm.showConnectPopUp.toggle()
		  }
		}label:{
		  Image(systemName: "person.badge.plus")
			 .font(.title2)
			 .foregroundStyle(theme.primaryDark)
		}
	 }
  }
}
