//
//  TodoEndpoint.swift
//  Folovers
//
//  Created by user on 01.09.2026.
//

import Foundation
import FirebaseFirestore


enum TodoEndpoint: FirestoreEndpoint{
  case getTodos(uid: String)
  case getUserTodaysTodos(userId: String)
  case create(uid: String, item: TodoItem)
  case update(uid: String, item: TodoItem)
  case delete(uid: String, id: String)
  var path: FirestoreReference{
	 switch self {
		case .getTodos(let id):
		return firestore.collection("Users").document(id).collection("todos")
	 case .getUserTodaysTodos(let uid):
		return firestore
		  .collection("Users").document(uid).collection("todos")
			 .whereField("createdAt", isGreaterThanOrEqualTo: Date.now.startOfDay)
			 .whereField("privacy", isEqualTo: TodoPrivacy.public.rawValue)
	 case  .create(let uid, let item):
		return firestore.collection("Users").document(uid).collection("todos").document()
	 case .update(let uid, let item):
		return firestore.collection("Users").document(uid).collection("todos").document(item.id)
	 case .delete(let uid, let id):
		return firestore.collection("Users").document(uid).collection("todos").document(id)
	 }
  }
  
  var method: FirestoreMethod{
	 switch self {
	 case .getTodos(_):
		  .get
	 case .getUserTodaysTodos(_):
		  .get
	 case .create(_, let item):
		  .post(item)
	 case .update(_, let item):
		  .put(item)
	 case .delete(_, _):
		  .delete
	 }
  }
}
