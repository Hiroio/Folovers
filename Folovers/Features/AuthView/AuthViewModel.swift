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
  
  
  var isValid: Bool {
	 email.isEmpty == false && password.isEmpty == false
  }
}
