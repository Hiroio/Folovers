//
//  ConnectionViewModel.swift
//  Folovers
//
//  Created by user on 20.08.2026.
//

import Foundation

@Observable
final class ConnectionViewModel{
  var connections: [ConnectionModel] = []
  var profiles: [String: UserDocument] {
	 connectionManager.profiles
  }
  var error: FirestoreError? = nil
  
  private let connectionManager = ConnectionManager.shared
  
  
  var activeConnections:  [ConnectionModel] {
	 connections.filter({ $0.status == .accepted})
  }
  
  var pendingConnections: [ConnectionModel]{
	 connections.filter({ $0.status == .pending})
  }
}



extension ConnectionViewModel{
  func fetchConnections(){
	 Task{
		do{
		  let connections = try await connectionManager.getConnections()
		  self.connections = connections
		}catch{
		  mapError(error)
		}
	 }
  }
  
  func createConnection(connection: ConnectionModel){
	 Task{
		do{
		  try await connectionManager.createConnection(connection)
		}catch{
		  mapError(error)
		}
	 }
  }
  
  func updateConnection(connection: ConnectionModel){
	 Task{
		do{
		  try await connectionManager.update(connection)
		}catch{
		  mapError(error)
		}
	 }
  }
  
  func deleteConnection(connection: ConnectionModel){
	 Task{
		do{
		  try await connectionManager.delete(connection)
		}catch{
		  mapError(error)
		}
	 }
  }
  
  
  func mapError(_ error: Error) {
	 guard let error = error as? FirestoreError else {
		self.error = .unknownError
		return
	 }
	 self.error = error
  }
}
