//
//  UserManager.swift
//  Folovers
//
//  Created by user on 12.08.2026.
//

import Foundation
import SpritePackage

@MainActor
@Observable
final class UserManager{
  static let shared = UserManager()
  
  var currentUser: UserDocument? = nil
  var isInitialized: Bool = false
  var error: FirestoreError? = nil
  
  
  init(){
	 
  }
  
  
  func tryToFetchUser(with id: String?){
	 guard let id else { return }
	 
	 Task{
		do{
		  let endpoint = UserEndpoint.getUser(id: id)
		  self.currentUser = try await FirestoreService.request(endpoint)
		  print("DEBUG User successfully fetched")
		}catch{
		  isInitialized.toggle()
		  print("DEBUG: -trying fetch user failed with error: \(error.localizedDescription)")
		}
	 }
  }
  
  
  func createUserDocument(character: CharacterConfig, displayName: String){
	 guard let id = AuthManager.shared.id else { return }
	 
	 Task{
		do{
		  let user = UserDocument(id: id, displayName: displayName, characterConfig: character)
		  let endpoint = UserEndpoint.postItem(item: user)
		  
		  try await FirestoreService.request(endpoint)
		  
		  self.currentUser = user
		  print("Created")
		}catch{
		  print("DEBUG: Failed to create USERFIRESTORE \(error.localizedDescription)")
		  if let error = error as? FirestoreError{
			 self.error = error
		  }else{
			 self.error = .unknownError
		  }
		}
	 }
  }
}


