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
	 if let user = userManager.currentUser{
		if self.mood == nil{
		  self.mood = user.mood
		}
		return user
	 }
	 return nil
  }
  
  var mood: CharacterMood? = nil
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
	 guard mood != self.mood else { return }
	 self.mood = mood
	 guard var userToUpdate = user else { return }
	 userToUpdate.mood = mood
	 
	 Task{
		print("Changing mood")
		if await userManager.updateUser(user: userToUpdate) {
		  print("Success")
		}
	 }
  }
}
