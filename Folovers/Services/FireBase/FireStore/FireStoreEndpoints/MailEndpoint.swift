//
//  MailEndpoint.swift
//  Folovers
//
//  Created by user on 26.08.2026.
//

import Foundation
import FirebaseFirestore


struct MailEndpoint: FirestoreEndpoint {
  enum Action {
	 case listener(userId: String)
	 case fetchAll(userId: String)
	 case fetchOne(mailId: String)
	 case create(MailModel)
	 case update(MailModel)
	 case delete(MailModel)
  }
  
  let action: Action
  
  var path: FirestoreReference {
	 switch action {
	 case .listener(let userId):
		firestore.collection("Mails").whereField("createdFor", isEqualTo: userId)
	 case .fetchAll(let userId):
		firestore.collection("Mails").whereField("createdBy", isEqualTo: userId)
	 case .fetchOne(let mailId):
		firestore.collection("Mails").document(mailId)
	 case .update(let mail), .delete(let mail):
		firestore.collection("Mails").document(mail.id)
	 case .create(_):
		firestore.collection("Mails").document()
	 }
  }
  
  var method: FirestoreMethod {
	 switch action {
	 case .fetchAll, .fetchOne: .get
	 case .listener: .listener
	 case .create(let model): .post(model)
	 case .update(let model): .put(model)
	 case .delete: .delete
	 }
  }
}
