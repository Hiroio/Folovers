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
  case plans(folderId: String)

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


enum NavigationPopUp {
  case userSearch, user(uid: String, user: UserDocument?)
  case folderCreation
}
