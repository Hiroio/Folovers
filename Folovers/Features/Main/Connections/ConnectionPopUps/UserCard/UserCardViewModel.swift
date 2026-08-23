//
//  UserCardViewModel.swift
//  Folovers
//
//  Created by user on 23.08.2026.
//

import Foundation


@Observable
final class UserCardViewModel{
  let uid: String
  var user: UserDocument?
  var loading: Bool = false
  var userLoading: Bool = false
  
  private let manager = ConnectionManager.shared
  private let userManager = UserManager.shared
  
  init(uid: String, user: UserDocument? = nil) {
	 if let user{
		self.user = user
		self.uid = uid
	 }else{
		self.uid = uid
		getUser(uid: uid)
	 }
  }
  
  var requestErrors: FirestoreError?{
	 manager.requestError
  }
  
  var connection: ConnectionModel?{
	 manager.connections.first(where: {$0.users.contains(uid)})
  }
  
  
  var btnStatus: ConnectionButtonState{
	 guard let connection else { return .none}
	 guard connection.status != .accepted else { return .connected }
	 guard uid != connection.requestedBy else { return .incoming}
	 
	 return .outgoing
	 
  }
}

extension UserCardViewModel{
  //  Pulls the profile into the shared cache. Does nothing if it is already there
  func loadUser() async {
	 guard user == nil else { return }
	 
	 userLoading = true
	 defer { userLoading = false }
	 
	 await manager.loadProfileIfNeeded(uid: uid)
  }
  
  //  Send Request
  func sendConnectionRequest() {
	 guard let id = AuthManager.shared.id, id != uid else { return }
	 
	 loading = true
	 
	 Task{
		defer{ loading = false}
		
		let uId: String = [id, uid].sorted().joined(separator: "_")
		let connection = ConnectionModel(id: uId, users: [id, uid], status: .pending, requestedBy: id, createdAt: .now)
		
		await manager.createConnection(connection)
	 }
  }
  
  //  Accept Request
  func acceptRequest() {
	 guard let connection else { return }
	 
	 loading = true
	 
	 Task{
		defer{ loading = false}
		var connectionToModify = connection
		
		connectionToModify.status = .accepted
		await manager.update(connectionToModify)
	 }
  }
  
  //  Cancel/Delete/Decline
  func deleteConnection() {
	 guard let connection else { return }
	 
	 loading = true
	 
	 Task{
		defer {loading = false }
		await manager.delete(connection)
	 }
  }
  
  
  func getUser(uid: String){
	 if let user = manager.profiles[uid]{
		self.user = user
	 }else{
		Task{
		  do{
			 let user = try await userManager.getUser(uid)
			 self.user = user
		  }catch{
			 NavigationManager.shared.popPopUp()
//			 Maybe in future add global systemPopUps for errors
		  }
		}
	 }
  }
}



enum ConnectionButtonState{
  case none
  case incoming
  case outgoing
  case connected
}
