//
//  UserManager.swift
//  Folovers
//
//  Created by user on 12.08.2026.
//

import Foundation


@MainActor
@Observable
final class UserManager{
  static let shared = UserManager()
  
  var currentUser: UserDocument? = nil
  var isInitialized: Bool = false
  
  
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
		  print("DEBUG: -trying fetch user failed with error: \(error.localizedDescription)")
		}
	 }
  }
}


