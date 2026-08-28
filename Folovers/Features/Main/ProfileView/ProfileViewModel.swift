//
//  ProfileViewModel.swift
//  Folovers
//
//  Created by user on 17.08.2026.
//

import Foundation
import SpritePackage

@Observable
final class ProfileViewModel{
  
  var showConnectPopUp: Bool = false
  var showProfileEditing: Bool = false
  
  private let userManager = UserManager.shared

//  One controller for the whole screen. A computed one rebuilt the SKScene on every
//  read, and SpriteView keeps the instance it got at init - so outfit changes
//  must go through updateOutfit on this very object
  private(set) var controller: CharacterController? = nil

  init(){
	 syncCharacter()
  }

  var currentUser: UserDocument? {
	 userManager.currentUser
  }

  func syncCharacter(){
	 guard let config = userManager.currentUser?.characterConfig else {
		controller = nil
		return
	 }

	 if let controller{
		controller.updateOutfit(config)
	 }else{
		controller = CharacterController(config: config)
	 }
  }
}
