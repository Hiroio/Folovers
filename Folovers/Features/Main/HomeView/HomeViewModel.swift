//
//  HomeViewModel.swift
//  Folovers
//
//  Created by user on 26.08.2026.
//

import Foundation

@Observable
final class HomeViewModel{
  var user: UserDocument?{
	 userManager.currentUser
  }
  
  private let userManager = UserManager.shared
//  private let mailManager =
}
