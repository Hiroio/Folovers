//
//  ProfileConnectView.swift
//  Folovers
//
//  Created by user on 17.08.2026.
//

import SwiftUI

struct ProfileConnectView: View {
  let nameSpace: Namespace.ID
  @Environment(ProfileViewModel.self) var vm
  @Environment(\.theme) var theme
    var body: some View {
		VStack(spacing: 25){
		  Text("Folovers")
			 .font(.title)
		  
		  VStack(spacing: 15){
			 SpriteView(action: .idle, controller: vm.controller)
				.matchedGeometryEffect(id: "Sprite", in: nameSpace)
			 
			 Text(vm.currentUser?.displayName ?? "Character")
				.font(.title2)
				.matchedGeometryEffect(id: "Name", in: nameSpace)
		  }
		  VStack{
			 copyElement(item: "us-app.com/invite/8f9a2", link: true)
			 copyElement(item: "\(AuthManager.shared.id ?? "Cannot find Id")", link: false)
		  }
		}
		.foregroundStyle(theme.primaryDark)
		.fontDesign(.monospaced)
		.card(15)
		.matchedGeometryEffect(id: "Connect", in: nameSpace)
		
    }
}

#Preview {
  @Previewable @Namespace var nameSpace
    ProfileConnectView(nameSpace: nameSpace)
	 .environment(\.theme, .basic)
	 .environment(ProfileViewModel())
}

extension ProfileConnectView{
  @ViewBuilder
  func copyElement(item: String, link: Bool) -> some View{
	 HStack(spacing: 15){
		Text("\(link ? "" : "UID: ")\(item)")
		  .font(.footnote)
		  .frame(maxWidth: .infinity, alignment: .leading)
		  .padding(15)
		  .background(
			 RoundedRectangle(cornerRadius: 15)
				.fill(.white)
		  )
		Button{
		  UIPasteboard.general.setValue(item, forPasteboardType: "public.plain-text")

		}label:{
		  Image(systemName: "rectangle.on.rectangle")
			 .font(.title3.weight(.semibold))
			 .border(15)
		}
	 }
	 .foregroundStyle(theme.primary)
  }
}
