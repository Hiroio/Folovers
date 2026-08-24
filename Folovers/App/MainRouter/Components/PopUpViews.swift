//
//  PopUpViews.swift
//  Folovers
//
//  Created by user on 23.08.2026.
//

import SwiftUI

struct PopUpViews: View {
  let popUp: NavigationPopUp
    var body: some View {
		switch popUp {
		case .userSearch:
		  SearchingUserPopUp()
			 .transition(.scale.combined(with: .opacity))
		case .user(let uid, let user):
		  UserCardPopUp(uid: uid, user: user)
			 .transition(.scale.combined(with: .opacity))
		case .folderCreation:
		  FolderCreationView()
			 .transition(.scale.combined(with: .opacity))
		}
    }
}

#Preview {
  PopUpViews(popUp: .userSearch)
}
