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
		if let currentUser, oldValue?.id != currentUser.id{
		  ConnectionManager.shared.startListener()
		  MailManager.shared.initializeManager()
		  TodosManager.shared.getTodos()
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
		}catch FirestoreError.documentNotFound{
//		  Authenticated but no profile yet - onboarding is exactly where this user belongs
		  print("DEBUG: no user document yet, going to onboarding")
		}catch{
//		  The request itself failed. Keeping the session would send the user
//		  to onboarding and make them build their character again
		  print("DEBUG: -trying fetch user failed with error: \(error.localizedDescription)")
		  NavigationManager.shared.addSystemUp(.get(.error, "Could not load your profile"))
		  AuthManager.shared.logOut()
		  return
		}
		isInitialized = true
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
		  NavigationManager.shared.addSystemUp(.get(.error, "Could not create your profile"))
		}
	 }
  }
  
  func getUser(_ id: String) async throws -> UserDocument{
	 let endpoint = UserEndpoint.getUser(id: id)
	 
	 return try await FirestoreService.request(endpoint)
  }
  
  func updateUser(user: UserDocument) async -> Bool {
	 guard user != currentUser else { return true }
	 let endpoint = UserEndpoint.updateItem(item: user)

	 do{
		try await FirestoreService.request(endpoint)
		self.currentUser = user
		return true
	 }catch{
		self.error = error as? FirestoreError ?? .unknownError
		NavigationManager.shared.addSystemUp(.get(.error, "Could not save your profile"))
		return false
	 }
  }
  
  func logOut(){
	 self.currentUser = nil
	 self.isInitialized = false
  }
}


