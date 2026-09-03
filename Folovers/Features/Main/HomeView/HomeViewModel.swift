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
  
//  No storage of its own - the profile is the source of truth. Writing to
//  self here would just call this setter again
  var mood: CharacterMood? {
	 get{
		userManager.currentUser?.mood
	 }
	 set{
		guard let newValue, newValue != mood else { return }
		changeMood(to: newValue)
	 }
  }
  var calendarActive: Bool = false
  
  var spriteAction: SpriteActions{
	 mood?.actions ?? .idle
  }
  
  private let userManager = UserManager.shared
  private let mailManager = MailManager.shared
  
  
  var unReadMessages: Int{
	 mailManager.mails.filter({$0.status == .sent}).count
  }
}


extension HomeViewModel{
  func changeMood(to mood: CharacterMood){
	 guard var userToUpdate = user else { return }
	 userToUpdate.mood = mood

	 Task{
		let _ = await userManager.updateUser(user: userToUpdate)
	 }
  }
}
