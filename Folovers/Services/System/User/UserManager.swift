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
  
  var currentUser: UserDocument? = nil{
	 didSet{
		if currentUser != nil{
		  ConnectionManager.shared.startListener()
		  FolderManager.shared.fetchAllRelated()
		}
	 }
  }
  var isInitialized: Bool = false
  var error: FirestoreError? = nil
  
  
  init(){
	 
  }
  
  
  func tryToFetchUser(with id: String?){
	 guard let id else { return }
	 Task{
		do{
		  self.currentUser = try await getUser(id)
		  print("DEBUG User successfully fetched")
		}catch{
		  print("DEBUG: -trying fetch user failed with error: \(error.localizedDescription)")
		}
		isInitialized.toggle()
	 }
  }
  
  
  func createUserDocument(character: CharacterConfig, displayName: String){
	 guard let id = AuthManager.shared.id else { return }
	 
	 Task{
		do{
		  let user = UserDocument(id: id, displayName: displayName, characterConfig: character, createdAt: .now)
		  let endpoint = UserEndpoint.postItem(item: user)
		  
		  try await FirestoreService.request(endpoint)
		  
		  self.currentUser = user
		  
		  let systemFolder = FolderModel.createPersonal(uid: id)
		  FolderManager.shared.createDefaultFolder(folder: systemFolder)
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
  
  func getUser(_ id: String) async throws -> UserDocument{
	 let endpoint = UserEndpoint.getUser(id: id)
	 
	 return try await FirestoreService.request(endpoint)
  }
  
  func logOut(){
	 self.currentUser = nil
	 self.isInitialized = false
  }
}


