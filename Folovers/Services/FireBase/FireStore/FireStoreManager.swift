//
//  FireStoreManager.swift
//  Folovers
//
//  Created by user on 11.08.2026.
//

import Foundation
import FirebaseFirestore

public final class FirestoreService {

	 init() {}

	 public static func request<T>(_ endpoint: FirestoreEndpoint, cacheFirst: Bool = false) async throws -> T where T: FirestoreIdentifiable {
		  guard let ref = endpoint.path as? DocumentReference else {
				throw FirestoreError.documentNotFound
		  }
		  switch endpoint.method {
		  case .get:
				if cacheFirst,
					let cachedSnapshot = try? await ref.getDocument(source: .cache),
					let cachedData = cachedSnapshot.data() {
					 return try FirestoreParser.parse(cachedData, type: T.self)
				}

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

	 public static func request<T>(_ endpoint: FirestoreEndpoint) async throws -> [T] where T: FirestoreIdentifiable {
		  guard let ref = endpoint.path as? Query else {
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
		  case .post, .put, .delete, .listener:
				throw FirestoreError.operationNotSupported
		  }
	 }

	 public static func request(_ endpoint: FirestoreEndpoint) async throws -> Void {
		  guard let ref = endpoint.path as? DocumentReference else {
				throw FirestoreError.documentNotFound
		  }
		  switch endpoint.method {
		  case .get, .listener:
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
  
  
  public static func stream<T>(_ endpoint: FirestoreEndpoint) -> AsyncThrowingStream<[T], Error> where T: FirestoreIdentifiable{
	 AsyncThrowingStream { continuation in
				guard let ref = endpoint.path as? Query else {
					 continuation.finish(throwing: FirestoreError.collectionNotFound)
					 return
				}
				
				guard endpoint.method == .listener else {
					 continuation.finish(throwing: FirestoreError.operationNotSupported)
					 return
				}
				
				let listener = ref.addSnapshotListener { querySnapshot, error in
					 if let error = error {
						  continuation.finish(throwing: error)
						  return
					 }
					 
					 guard let querySnapshot = querySnapshot else { return }

//					 A broken document is skipped, the stream stays alive
					 let response: [T] = querySnapshot.documents.compactMap { document in
						  do {
								return try FirestoreParser.parse(document.data(), type: T.self)
						  } catch {
								print("DEBUG: Skipped \(T.self) \(document.documentID): \(error)")
								return nil
						  }
					 }

					 continuation.yield(response)
				}
				
				continuation.onTermination = { _ in
					 listener.remove()
				}
		  }
	 }

}
