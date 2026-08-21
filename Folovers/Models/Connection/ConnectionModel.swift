//
//  ConnectionModel.swift
//  Folovers
//
//  Created by user on 20.08.2026.
//

import Foundation

struct ConnectionModel: FirestoreIdentifiable{
  var id: String
  var users: [String]
  var status: ConnectionStatus
  var requestedBy: String
  var createdAt: Date
}



extension ConnectionModel{
  static func conncetion(id: String) -> ConnectionModel{
	 .init(id: id, users: [id, "qw#4e2r"], status: .accepted, requestedBy: id, createdAt: .now)
  }
}

enum ConnectionStatus: Codable, CaseIterable{
  case accepted, pending
  
  
  
  var title: String{
	 switch self {
	 case .pending:
		"Pending"
	 case .accepted:
		"Connected"
	 }
  }
}
