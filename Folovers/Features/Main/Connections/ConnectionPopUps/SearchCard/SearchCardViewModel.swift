//
//  SearchCardViewModel.swift
//  Folovers
//
//  Created by user on 23.08.2026.
//

import Foundation


@Observable
final class SearchCardViewModel{
  var searchText: String = ""
  
  var errorText: String? = nil
  var loading: Bool = false
  private let userManager = UserManager.shared
  private let connectionManager = ConnectionManager.shared
  
  func searchUser(){
	 loading = true
	 let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
	 guard text != AuthManager.shared.id else {
		invalidUser(message: "That's your ID")
		return
	 }
	 
	 if let connection = connectionManager.connections.first(where: {$0.users.contains(text)}){
		NavigationManager.shared.popUps.append(.user(uid: text, user: nil))
	 }else{
		getUser(with: text)
	 }
	 
	 loading = false
	 
  }
  
  func getUser(with text: String){
	 Task{
		do{
		  let user = try await userManager.getUser(text)
		  NavigationManager.shared.popUps.append(.user(uid: user.id, user: user))
		}catch{
		  invalidUser()
		}
	 }
  }
  func invalidUser(message: String = "User Not found"){
	 self.errorText = message
  }
}
