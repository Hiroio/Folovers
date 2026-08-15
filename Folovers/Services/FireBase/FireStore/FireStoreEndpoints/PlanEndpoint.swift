//
//  PlanEndpoint.swift
//  Folovers
//
//  Created by user on 15.08.2026.
//

import Foundation
import FirebaseFirestore


struct PlanEndpoint: FirestoreEndpoint {
	 enum Action {
		  case fetchAll(folderId: String)
		  case fetchOne(planId: String)
		  case create(PlanCard)
		  case update(planId: String, PlanCard)
		  case delete(planId: String)
	 }

	 let action: Action

	 var path: FirestoreReference {
		  switch action {
		  case .fetchAll(let folderId):
			 firestore.collection("plans").whereField("folderId", isEqualTo: folderId)
		  case .fetchOne(let planId), .update(let planId, _), .delete(let planId):
				firestore.collection("plans").document(planId)
		  case .create:
				firestore.collection("plans").document()
		  }
	 }

	 var method: FirestoreMethod {
		  switch action {
		  case .fetchAll, .fetchOne: .get
		  case .create(let model): .post(model)
		  case .update(_, let model): .put(model)
		  case .delete: .delete
		  }
	 }
}
