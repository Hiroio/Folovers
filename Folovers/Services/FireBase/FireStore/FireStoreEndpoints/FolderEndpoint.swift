//
//  FolderEndpoint.swift
//  Folovers
//
//  Created by user on 16.08.2026.
//

import Foundation
import FirebaseFirestore


struct FolderEndpoint: FirestoreEndpoint {
  enum Action {
	 case fetchAll(userId: String)
	 case fetchOne(folderId: String)
	 case create(FolderModel)
	 case update(FolderModel)
	 case delete(FolderModel)
  }
  
  let action: Action
  
  var path: FirestoreReference {
	 switch action {
	 case .fetchAll(let userId):
		firestore.collection("Folders").whereField("members", arrayContains: userId)
	 case .fetchOne(let folderId):
		firestore.collection("Folders").document(folderId)
	 case .update(let folder), .delete(let folder):
		firestore.collection("Folders").document(folder.id)
	 case .create(_):
		firestore.collection("Folders").document()
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

