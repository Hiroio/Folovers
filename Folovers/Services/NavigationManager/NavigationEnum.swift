//
//  NavigationEnum.swift
//  Folovers
//
//  Created by user on 12.08.2026.
//

import Foundation
import SwiftUI

enum StartNavigationFlow{
		case longLoading
		case shortLoading
		case unauthenticated
		case needsOnboarding
		case ready
}


enum MainNavigationFlow: String, Identifiable, CaseIterable{
  case home
  case folders
  case connections
  case profile
  
  
  var id: String {
	 self.rawValue
  }
  
  var icon: String{
	 switch self {
	 case .home:
		"house"
	 case .folders:
		"folder"
	 case .connections:
		"person.line.dotted.person"
	 case .profile:
		"person"
	 }
  }
}


enum SecondaryViewsEnum: Identifiable{
  case plans(folder: FolderModel)

  var id: Int{
	 switch self {
	 case .plans(_):
		1
	 }
  }

  var transition: AnyTransition{
	 switch self {
	 case .plans(_):
		  .move(edge: .bottom).combined(with: .opacity)
	 }
  }
  
}


enum NavigationPopUp: Identifiable, Equatable {
  
  
  case userSearch, user(uid: String, user: UserDocument?)
  case folderCreation
  case letterCreation(to: String)
  case letter(MailModel)
  case mailBox
  case photo(photoKF: String?, photoUI: UIImage?)
  
  
  var id: String{
	 switch self {
	 case .userSearch:
		"UserSearch"
	 case .user(_, _):
		"User"
	 case .folderCreation:
		"FolderCreation"
	 case .letterCreation(_):
		"letterCreation"
	 case .letter(_):
		"letter"
	 case .photo(_, _):
		"Photo"
	 case .mailBox:
		"mailBox"
	 }
  }
  
  static func == (lhs: NavigationPopUp, rhs: NavigationPopUp) -> Bool {
	 return lhs.id == rhs.id
  }
}
