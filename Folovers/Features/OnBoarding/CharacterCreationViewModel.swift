//
//  CharacterCreationViewModel.swift
//  Folovers
//
//  Created by user on 14.08.2026.
//

import Foundation
import SpritePackage

@Observable
final class CharacterCreationViewModel{
  var character: CharacterConfig = .standart {
	 didSet {
		characterController.updateOutfit(character)
	 }
  }
  var characterName: String = ""
 
  var nameIsGiven: Bool = false
  var user: UserDocument? = nil
  var isEditing: Bool = false
  
  var characterController: CharacterController
  
  init(user: UserDocument? = nil){
	 self.isEditing = user != nil
	 self.nameIsGiven = user != nil
	 let controller = CharacterController(config: user?.characterConfig ?? .standart)
	 self.characterController = controller
	 self.character = user?.characterConfig ?? .standart
	 self.user = user
	 self.characterName = user?.displayName ?? ""
	 
  }
 
  private let manager = UserManager.shared
  
  var isMale: Bool{
	 character.gender == .male
  }
}


extension CharacterCreationViewModel{
  func changeGender(){
	 character.gender = character.gender == .female ? .male : .female
  }
  
  func changeHairStyle(to hair: HairStyle){
	 character.hair = hair
  }
  
  func changeBottom(to bottom: BottomStyle){
	 character.bottom = bottom
  }
  
  func changeTop(to top: TopStyle){
	 character.top = top
  }
  
  
  func createDocument(){
	 manager.createUserDocument(character: character, displayName: characterName)
  }
  
  func updateUserDocument() async -> Bool{
	 guard let user else {return true}
	 var userToUpdate = user
	 userToUpdate.displayName = characterName
	 userToUpdate.characterConfig = character
	 
	 return await manager.updateUser(user: userToUpdate)
  }
}
