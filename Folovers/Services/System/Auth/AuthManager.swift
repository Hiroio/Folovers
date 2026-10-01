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

//  Same SSO result as continueWithSSO, but for linking a provider onto an
//  already-signed-in account - that happens from Profile, where nothing
//  reads `error`, so it needs its own visible feedback
  func linkSSO(_ result: Result<AuthUser, AuthError>) {
	 switch result {
	 case .success(let user):
		self.currentUser = user
		NavigationManager.shared.addSystemUp(.get(.success, "Account linked"))
	 case .failure(let failure):
		self.error = failure
		NavigationManager.shared.addSystemUp(.get(.error, failure.localizedDescription))
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

//  Works for an email/password account and doubles as "set a password" for
//  a Google/Apple-only one - Firebase sends the same reset link either way
  func resetPassword(){
	 guard let email = currentUser?.email else {
		NavigationManager.shared.addSystemUp(.get(.error, "No email on this account"))
		return
	 }

	 Task{
		do{
		  try await service.sendPasswordReset(email: email)
		  NavigationManager.shared.addSystemUp(.get(.success, "Password reset email sent"))
		}catch{
		  self.error = getError(error: error)
		  NavigationManager.shared.addSystemUp(.get(.error, getError(error: error).localizedDescription))
		}
	 }
  }
}
