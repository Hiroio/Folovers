//
//  FireStoreEndpoint.swift
//  Folovers
//
//  Created by user on 11.08.2026.
//

import Foundation
import FirebaseFirestore

// MARK: - FirestoreEndpoint

public typealias FirestoreQuery = Query

public protocol FirestoreEndpoint {
	 var path: FirestoreReference { get }
	 var method: FirestoreMethod { get }
	 var firestore: Firestore { get }
}

public extension FirestoreEndpoint {
	 var firestore: Firestore {
		  Firestore.firestore()
	 }
}

// MARK: - FirestorePath

public enum FirestorePath {
	 case collection(reference: CollectionReference)
	 case document(reference: DocumentReference)
}

// MARK: - FirestoreMethod

public enum FirestoreMethod: Identifiable, Equatable {
  public static func == (lhs: FirestoreMethod, rhs: FirestoreMethod) -> Bool {
	 lhs.id == rhs.id
  }
  
  case get
  case post(any FirestoreIdentifiable)
  case put(any FirestoreIdentifiable)
  case listener
  case delete
  
  public var id: String{
	 switch self {
	 case .get:
		"get"
	 case .post(let firestoreIdentifiable):
		"post"
	 case .put(let firestoreIdentifiable):
		"put"
	 case .listener:
		"listener"
	 case .delete:
		"delete"
	 }
  }
  
  
}


public protocol FirestoreReference {
	 // You can define common methods/properties here, if needed
}

extension DocumentReference: FirestoreReference { }
extension Query: FirestoreReference {}






