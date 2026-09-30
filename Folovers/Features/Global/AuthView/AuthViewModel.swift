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
	 isValidEmail && password.isEmpty == false
  }

//  Standard shape check, not a guarantee the address exists - Firebase still
//  has the final say and maps a truly bad one to AuthError.invalidEmail
  private var isValidEmail: Bool {
	 let pattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
	 return email.range(of: pattern, options: .regularExpression) != nil
  }
  
  
  private let manager = AuthManager.shared
  
  func clearError(){
	 manager.error = nil
  }
  
  func logInWithEmail(){
	 manager.emailLogin(email: email, password: password)
  }
}
