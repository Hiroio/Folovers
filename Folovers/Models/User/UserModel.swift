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
}
