//
//  UserEndpoint.swift
//  Folovers
//
//  Created by user on 12.08.2026.
//

import Foundation
import FirebaseFirestore


enum UserEndpoint: FirestoreEndpoint{
  case getUser(id: String)
  case postItem(item: UserDocument)
  case updateItem(item: UserDocument)
  
  var path: FirestoreReference{
	 switch self {
	 case .getUser(let id):
		return firestore.collection("Users").document(id)
	 case .postItem(let item):
		return firestore.collection("Users").document(item.id)
	 case .updateItem(let item):
		return firestore.collection("Users").document(item.id)
	 }
  }
  
  var method: FirestoreMethod{
	 switch self {
	 case .getUser:
		  .get
	 case .postItem(let item):
		  .post(item)
	 case .updateItem(let item):
		  .put(item)
	 }
  }
}
