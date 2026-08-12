//
//  FireStoreIdentifiable.swift
//  Folovers
//
//  Created by user on 11.08.2026.
//

import Foundation


public protocol FirestoreIdentifiable: Codable, Identifiable {
	 var id: String { get set }
}

extension Encodable {
  func asDictionary() -> [String: Any] {
		  guard let data = try? JSONEncoder().encode(self) else {
				return [:]
		  }
		  guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
				return [:]
		  }
		  return dictionary
	 }
}
