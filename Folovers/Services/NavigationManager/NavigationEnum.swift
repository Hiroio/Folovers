//
//  NavigationEnum.swift
//  Folovers
//
//  Created by user on 12.08.2026.
//

import Foundation

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
	 case .profile:
		"person"
	 }
  }
}
