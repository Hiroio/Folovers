//
//  AuthManager.swift
//  Folovers
//
//  Created by user on 12.08.2026.
//

import Foundation
import AuthLibrary

@MainActor
@Observable
final class AuthManager{
  static let shared = AuthManager()
  
  var currentUser: AuthUser? = nil{
	 didSet{
		if let currentUser{
		  UserManager.shared.tryToFetchUser(with: currentUser.uid)
		}
	 }
  }
  var error: AuthError? = nil
  
  let service = AuthLibrary.FirebaseAuthService()
  
  init() {
	 initializeCheck()
  }
  
  var id: String?{
	 self.currentUser?.uid
  }
  
  func initializeCheck() {
	 if let user = service.getCurrentUser(){
		self.currentUser = user
	 }
  }
  
  
  func logOut(){
	 do {
		try service.logout()
		currentUser = nil
		UserManager.shared.logOut()
		ConnectionManager.shared.stopListener()
	 }catch{
		print("failed")
	 }
  }
}

extension AuthManager{
  func continueWithSSO(_ result: Result<AuthUser, AuthError>) {
	 switch result {
	 case .success(let user):
		self.currentUser = user
	 case .failure(let failure):
		self.error = failure
	 }
  }
  
  func emailLogin(email: String, password: String) {
	 error = nil
	 Task{
		do{
		  currentUser = try await service.signInWithEmail(email: email, password: password)
		}catch AuthError.userNotFound{
		  await createAccount(email: email, password: password)
		}catch{
		  self.error = getError(error: error)
		}
	 }
  }
  
  func createAccount(email: String, password: String) async{
	 do{
		currentUser = try await service.signUpWithEmail(email: email, password: password)
	 }catch{
		self.error = getError(error: error)
	 }
  }
  
  private func getError(error: Error) -> AuthError {
	 guard let authError = error as? AuthError else {
		return .somethingWentWrong
	 }
	 return authError
  }
}
