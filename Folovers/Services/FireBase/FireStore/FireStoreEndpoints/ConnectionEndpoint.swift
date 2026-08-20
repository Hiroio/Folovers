//
//  ConnectionEndpoint.swift
//  Folovers
//
//  Created by user on 20.08.2026.
//

import Foundation
import FirebaseFirestore


struct ConnectionEndpoint: FirestoreEndpoint {
  enum Action {
	 case fetchAll(userId: String)
	 case fetchOne(connectionID: String)
	 case create(ConnectionModel)
	 case update(ConnectionModel)
	 case delete(ConnectionModel)
  }
  
  let action: Action
  
  var path: FirestoreReference {
	 switch action {
	 case .fetchAll(let userId):
		firestore.collection("Connections").whereField("users", arrayContains: userId)
	 case .fetchOne(let connectionId):
		firestore.collection("Connections").document(connectionId)
	 case .update(let connection), .delete(let connection):
		firestore.collection("Connections").document(connection.id)
	 case .create(let connection):
		firestore.collection("Connections").document(connection.id)
	 }
  }
  
  var method: FirestoreMethod {
	 switch action {
	 case .fetchAll, .fetchOne: .get
	 case .create(let model): .post(model)
	 case .update(let model): .put(model)
	 case .delete: .delete
	 }
  }
}
