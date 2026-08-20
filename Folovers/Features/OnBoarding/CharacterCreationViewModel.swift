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
  
  var characterController: CharacterController
  
  init(){
	 let controller = CharacterController(config: .standart, sceneSize: CGSize(width: 96, height: 96))
	 self.characterController = controller
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
	 print("Creating")
	 manager.createUserDocument(character: character, displayName: characterName)
  }
}
