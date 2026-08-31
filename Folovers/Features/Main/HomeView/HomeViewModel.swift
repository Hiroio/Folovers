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

  var mood: CharacterMood? = nil
  
  var calendarActive: Bool = false
  var calendarSheet: Bool = false

  var spriteAction: SpriteActions{
	 mood?.actions ?? .idle
  }
  
  private let userManager = UserManager.shared
  private let mailManager = MailManager.shared
  
  
  var unReadMessages: Int{
	 mailManager.mails.filter({$0.status == .sent}).count
  }
}
