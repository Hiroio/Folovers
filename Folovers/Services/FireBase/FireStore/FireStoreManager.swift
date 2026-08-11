//
//  FireStoreManager.swift
//  Folovers
//
//  Created by user on 11.08.2026.
//

import Foundation
import FirebaseFirestore

public final class FirestoreService {

	 private init() {}

	 public static func request<T>(_ endpoint: FirestoreEndpoint) async throws -> T where T: Codable {
		  guard let ref = endpoint.path as? DocumentReference else {
				throw FirestoreError.documentNotFound
		  }
		  switch endpoint.method {
		  case .get:
				guard let documentSnapshot = try? await ref.getDocument() else {
					 throw FirestoreError.invalidPath
				}

				guard let documentData = documentSnapshot.data() else {
					 throw FirestoreError.parseError
				}

				let singleResponse = try FirestoreParser.parse(documentData, type: T.self)
				return singleResponse
		  default:
				throw FirestoreError.invalidRequest
		  }

	 }

	 public static func request<T>(_ endpoint: FirestoreEndpoint) async throws -> [T] where T: Codable {
		  guard let ref = endpoint.path as? CollectionReference else {
				throw FirestoreError.collectionNotFound
		  }
		  switch endpoint.method {
		  case .get:
				let querySnapshot = try await ref.getDocuments()
				var response: [T] = []
				for document in querySnapshot.documents {
					 let data = try FirestoreParser.parse(document.data(), type: T.self)
					 response.append(data)
				}
				return response
		  case .post, .put, .delete:
				throw FirestoreError.operationNotSupported
		  }
	 }

	 public static func request(_ endpoint: FirestoreEndpoint) async throws -> Void {
		  guard let ref = endpoint.path as? DocumentReference else {
				throw FirestoreError.documentNotFound
		  }
		  switch endpoint.method {
		  case .get:
				throw FirestoreError.invalidRequest
		  case .post(var model):
				model.id = ref.documentID
				try await ref.setData(model.asDictionary())
		  case .put(let model):
				try await ref.setData(model.asDictionary())
		  case .delete:
				try await ref.delete()
		  }
	 }
}
