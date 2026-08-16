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
	 case fetchOne(folderId: String, planId: String)
	 case create(PlanCard)
	 case update(PlanCard)
	 case delete(PlanCard)
  }
  
  let action: Action
  
  var path: FirestoreReference {
	 switch action {
	 case .fetchAll(let folderId):
		firestore.collection("Folders").document(folderId).collection("Plans")
	 case .fetchOne(let folderId, let planId):
		firestore.collection("Folders").document(folderId).collection("Plans").document(planId)
	 case .update(let plan), .delete(let plan):
		firestore.collection("Folders").document(plan.folderId).collection("Plans").document(plan.id)
	 case .create(let plan):
		firestore.collection("Folders").document(plan.folderId).collection("Plans").document()
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
