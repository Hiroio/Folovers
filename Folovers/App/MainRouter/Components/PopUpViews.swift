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
		  
		case .folderCreation(let user):
		  FolderCreationView(preselected: user)
			 .transition(.scale.combined(with: .opacity))
		  
		case .photo(let photoKF, let photo):
		  PhotoPreviewView(photo: photo, photoURL: photoKF)
			 .transition(.move(edge: .bottom))
		  
		case .letterCreation(let to):
		  LetterCreationView(uid: to)
			 .transition(.opacity)
		  
		case .mailBox:
		  MailView()
			 .transition(.move(edge: .bottom))
		  
		case .letter(let letter):
		  LetterView(letter: letter)
			 .transition(.scale.combined(with: .opacity))

		case .confirmation(let model):
		  ConfirmationPopUp(model: model)
			 .transition(.scale.combined(with: .opacity))
		}
    }
}

#Preview {
  PopUpViews(popUp: .userSearch)
}
