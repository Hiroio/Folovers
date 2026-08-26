//
//  UserModel.swift
//  Folovers
//
//  Created by user on 12.08.2026.
//

import Foundation
import SpritePackage

struct UserDocument: FirestoreIdentifiable{
  var id: String
  var displayName: String
  var characterConfig: SpritePackage.CharacterConfig
  var createdAt: Date
}


extension UserDocument{
  static func placeholder(id: String) -> UserDocument{
	 UserDocument(id: id, displayName: "User\(id.suffix(4))", characterConfig: .standart, createdAt: .distantPast)
  }

//  Someone outside of our connections. We never fetch them, they just stay a mystery
  static func unknown(id: String) -> UserDocument{
	 UserDocument(id: id, displayName: "Unknown User", characterConfig: .standart, createdAt: .distantPast)
  }
}
