//
//  UserModel.swift
//  Folovers
//
//  Created by user on 12.08.2026.
//

import Foundation
import SpritePackage

struct UserDocument: FirestoreIdentifiable, Equatable{
  var id: String
  var displayName: String
  var mood: CharacterMood?
  var characterConfig: SpritePackage.CharacterConfig
  var createdAt: Date
  
  
  static func ==(lhs: UserDocument, rhs: UserDocument) -> Bool{
	 return lhs.id == rhs.id &&
	 lhs.characterConfig.bottom == rhs.characterConfig.bottom &&
	 lhs.characterConfig.top == rhs.characterConfig.top &&
	 lhs.characterConfig.hair == rhs.characterConfig.hair &&
	 lhs.characterConfig.gender == rhs.characterConfig.gender &&
	 lhs.mood == rhs.mood &&
	 lhs.displayName == rhs.displayName
	 
  }
}


extension UserDocument{
  static func placeholder(id: String) -> UserDocument{
	 UserDocument(id: id, displayName: "User\(id.suffix(4))", characterConfig: .standart, createdAt: .distantPast)
  }

//  Someone outside of our connections. We never fetch them, they just stay a mystery
  static func unknown(id: String) -> UserDocument{
	 UserDocument(id: id, displayName: "Unknown User", characterConfig: .standart, createdAt: .distantPast)
  }
  
  
  var isMale: Bool {
	 characterConfig.gender == .male
  }
}
