//
//  PrivacyLinksView.swift
//  Folovers
//
//  Created by user on 01.10.2026.
//

import SwiftUI

struct PrivacyLinksView: View {
  @Environment(\.theme) var theme
  @State private var privacyExpanded: Bool = false
  @State private var userManager = UserManager.shared

  private var todoListVisible: Bool{
	 userManager.currentUser?.todoPrivacy ?? true
  }

  private var todoListVisibleBinding: Binding<Bool>{
	 Binding{
		todoListVisible
	 }set: { newValue in
		guard var user = userManager.currentUser else { return }
		user.todoPrivacy = newValue
		Task{ _ = await userManager.updateUser(user: user) }
	 }
  }

	 var body: some View {
		VStack{
		  Button{
			 withAnimation(){
				privacyExpanded.toggle()
			 }
		  }label: {
			 HStack{
				LinkRow(.privacy)
				Image(systemName: "chevron.right")
				  .foregroundStyle(theme.secondaryText)
				  .rotationEffect(Angle(degrees: privacyExpanded ? 90 : 0))
			 }
			 .contentShape(.rect)
		  }

		  if privacyExpanded{
			 HStack{
				Rectangle()
				  .frame(width: 2)
				  .fixedSize(horizontal: false, vertical: true)
				  .padding(.leading, 5)
				VStack(alignment: .leading, spacing: 5){
				  HStack{
					 LinkRow(.todo)
					 CustomToggle(isOn: todoListVisibleBinding)
						.containerRelativeFrame(.horizontal, count: 5, spacing: 10)
				  }

				  Text("Todo list visibility")
					 .font(.caption)
					 .foregroundStyle(theme.secondaryText)
					 .padding(.leading, 15)
				}
				.frame(maxWidth: .infinity, alignment: .leading)
			 }
			 .padding(.horizontal)
		  }
		}
		.animation(.easeInOut, value: todoListVisible)
	 }
}

#Preview {
	PrivacyLinksView()
	  .environment(\.theme, .basic)
}
