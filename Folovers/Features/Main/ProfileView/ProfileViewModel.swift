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
  
  
  private let userManager = UserManager.shared
  
  var currentUser: UserDocument? {
	 userManager.currentUser
  }
  
  var controller: CharacterController? {
	 guard let config = userManager.currentUser?.characterConfig else {return nil}
	 return CharacterController(config: config, sceneSize: CGSize(width: 96, height: 96))
  }
}
