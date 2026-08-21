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
  var connectionsView: ConnectionStatus = .accepted
  
  private let connectionManager = ConnectionManager.shared
  
  init(){
	 fetchConnections()
  }
  
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
  
  
  @discardableResult
  func mapError(_ error: Error) -> FirestoreError{
	 guard let error = error as? FirestoreError else {
		self.error = .unknownError
		return .unknownError
	 }
	 self.error = error
	 return error
  }
}



enum ConnectionsState: Equatable {
  case empty
  case error(error: FirestoreError)
  case pendingEmpty
  
  
  
  var image: String{
	 switch self {
	 case .empty:
		"NoConnections"
	 case .error(_):
		"FailedToLoad"
	 case .pendingEmpty:
		"PendingEmpty"
	 }
  }
  
  var text: String{
	 switch self {
	 case .empty:
		"No connections yet!"
	 case .error(_):
		"Failed to load Connections"
	 case .pendingEmpty:
		"No any requests"
	 }
  }
  
  var actionBtn: String{
	 switch self {
	 case .empty:
		"Create Connections"
	 case .error(_):
		"Try Again"
	 case .pendingEmpty:
		""
	 }
  }
}
