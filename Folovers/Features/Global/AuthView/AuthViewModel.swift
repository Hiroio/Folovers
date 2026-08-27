//
//  AuthViewModel.swift
//  Folovers
//
//  Created by user on 12.08.2026.
//

import Foundation

@Observable
final class AuthViewModel{
  var email: String = ""
  var password: String = ""
  
  var passwordIsVisible: Bool = false
  
  var error: String? {
	 manager.error?.localizedDescription
  }
  
  var isValid: Bool {
	 email.contains("@") && password.isEmpty == false
  }
  
  
  private let manager = AuthManager.shared
  
  func clearError(){
	 manager.error = nil
  }
  
  func logInWithEmail(){
	 manager.emailLogin(email: email, password: password)
  }
}
