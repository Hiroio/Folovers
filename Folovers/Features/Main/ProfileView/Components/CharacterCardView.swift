//
//  CharacterCardView.swift
//  Folovers
//
//  Created by user on 17.08.2026.
//

import SwiftUI

struct CharacterCardView: View {
  let profileNameSpace: Namespace.ID
  @Environment(\.theme) var theme
  @Environment(ProfileViewModel.self) var vm
    var body: some View {
		VStack(spacing: 15){
			 if let controller = vm.controller{
				SpriteView(action: .idle, controller: controller)
				  .matchedGeometryEffect(id: "Sprite", in: profileNameSpace)
			 }
		  Text(vm.currentUser?.displayName ?? "Characte Name")
				.font(.headline.weight(.semibold))
				.foregroundStyle(theme.primaryDark)
				.matchedGeometryEffect(id: "Name", in: profileNameSpace)
		  }
		  .frame(maxWidth: .infinity)
		  .card(20)
		  .matchedGeometryEffect(id: "Connect", in: profileNameSpace)
		  .overlay(alignment: .topTrailing) {
			 Button{
				vm.showProfileEditing = true
			 }label:{
				Image(systemName: "pencil")
				  .font(.headline.weight(.bold))
				  .foregroundStyle(theme.primary)
				  .card(10)
				  .padding(5)
			 }
		  }
		  .fontDesign(.monospaced)
    }
}

#Preview {
  @Previewable @Namespace var nameSpace
    CharacterCardView(profileNameSpace: nameSpace)
	 .environment(\.theme, .basic)
	 .environment(ProfileViewModel())
}
