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





enum ConnectionStatus: Codable{
  case pending, accepted
}
