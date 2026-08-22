//
//  SearchingUserPopUp.swift
//  Folovers
//
//  Created by user on 22.08.2026.
//

import SwiftUI

struct SearchingUserPopUp: View {
  @Environment(\.theme) var theme
  @State private var text: String = ""
    var body: some View {
		VStack{
		  Header
		  
		  VStack{
			 Text("User ID")
				.font(.subheadline.weight(.semibold))
				.foregroundStyle(theme.primaryDark)
			 TextField("", text: $text, prompt:
							 Text("Enter user ID...")
				.foregroundStyle(theme.secondaryText)
			 )
			 .textFieldModifier()
			 .border(color: theme.primaryDark)
			 
//			 TODO: Erorr here
			 if true{
				HStack{
				  Image(systemName: "exclamationmark.circle")
				  
				  Text("Error text here!")
				}
				.font(.caption)
				.foregroundStyle(theme.primaryDark)
			 }
		  }
		  
		  
		  Button{
//			 TODO: implement search
		  }label:{
			 Text("Search")
				.frame(maxWidth: .infinity)
		  }
		  .buttonStyle(CustomAnimationForBtn(light: true))
		}
		.card(15, lineWidth: 3)
    }
}

#Preview {
    SearchingUserPopUp()
	 .environment(\.theme, .basic)
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
