//
//  ConnectionViewModel.swift
//  Folovers
//
//  Created by user on 20.08.2026.
//

import Foundation

@Observable
final class ConnectionViewModel{
  var connections: [ConnectionModel] {
	 connectionManager.connections
  }
  var profiles: [String: UserDocument] {
	 connectionManager.profiles
  }
  var connectionsError: FirestoreError? {
	 connectionManager.connectionsError
  }
  var requestError: FirestoreError? {
	 connectionManager.requestError
  }
  var connectionsView: ConnectionStatus = .accepted

  private let connectionManager = ConnectionManager.shared

  init(){
  }
  
  var activeConnections:  [ConnectionModel] {
	 connections.filter({ $0.status == .accepted})
  }
  
  var pendingConnections: [ConnectionModel]{
	 connections.filter({ $0.status == .pending})
  }
}



extension ConnectionViewModel{

//  Accept
  func acceptConnection(connection: ConnectionModel){
	 var connectionToAccept = connection
	 connectionToAccept.status = .accepted
	 Task{
		await connectionManager.update(connectionToAccept)
	 }
  }

//  DECLINE/Delete
  func deleteConnection(connection: ConnectionModel){
	 Task{
		await connectionManager.delete(connection)
	 }
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
		"Send an Request"
	 }
  }
}
