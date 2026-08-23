//
//  SearchingUserPopUp.swift
//  Folovers
//
//  Created by user on 22.08.2026.
//

import SwiftUI

struct SearchingUserPopUp: View {
  @Environment(\.theme) var theme
  @State private var vm = SearchCardViewModel()
    var body: some View {
		VStack(spacing: 25){
		  Header
		  
		  VStack(alignment: .leading){
			 Text("User ID")
				.font(.subheadline.weight(.semibold))
				.foregroundStyle(theme.primaryDark)
			 TextField("", text: $vm.searchText, prompt:
							 Text("Enter user ID...")
				.foregroundStyle(theme.secondaryText)
			 )
			 .textFieldModifier()
			 .border(color: theme.primaryDark)
			 .overlay(alignment: .trailing){
				ZStack{
				  if !vm.searchText.isEmpty{
					 Button{vm.searchText = ""}label: {
						Image(systemName: "xmark")
						  .foregroundStyle(theme.primary)
					 }
				  }
				}
				.padding(.horizontal)
			 }
			 
//			 TODO: Erorr here
			 if let errorText = vm.errorText{
				HStack{
				  Image(systemName: "exclamationmark.circle")
				  
				  Text(errorText)
				}
				.transition(.move(edge: .top).combined(with: .opacity))
				.font(.caption)
				.foregroundStyle(theme.primaryDark)
				.onAppear{
				  Task{
					 try await Task.sleep(for: .seconds(2))
					 self.vm.errorText = nil
				  }
				}
			 }
		  }
		  
		  
		  Button{
			 vm.searchUser()
		  }label:{
			 Text("Search")
				.font(.headline.weight(.medium))
				.frame(maxWidth: .infinity)
				.foregroundStyle(theme.primaryDark)
				.card(15)
				.compositingGroup()
		  }
		  .buttonStyle(CustomAnimationForBtn(light: true))
		}
		.card(15, lineWidth: 3)
		.padding(.horizontal)
		.compositingGroup()
		.animation(.easeInOut, value: vm.errorText != nil)
		.animation(.easeInOut, value: vm.searchText)
    }
}

#Preview {
    SearchingUserPopUp()
	 .environment(\.theme, .basic)
	 .fontDesign(.monospaced)
}


extension SearchingUserPopUp{
  var Header: some View{
	 HStack{
		Image(systemName: "magnifyingglass")
		Text("Find User")
		  .font(.title3.weight(.semibold))
		  .foregroundStyle(theme.text)
		  .frame(maxWidth: .infinity, alignment: .leading)
		
		Button{
		  NavigationManager.shared.popUps = []
		}label:{
		  Image(systemName: "xmark")
		}
	 }
	 .foregroundStyle(theme.primaryDark)
  }
}
