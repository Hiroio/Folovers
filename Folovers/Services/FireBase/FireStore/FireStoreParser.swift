//
//  FireStoreParser.swift
//  Folovers
//
//  Created by user on 11.08.2026.
//

import Foundation

struct FirestoreParser {

  static func parse<T: Decodable>(_ documentData: Dictionary<String, Any>, type: T.Type) throws -> T {
		  do {
				let jsonData = try JSONSerialization.data(withJSONObject: documentData, options: [])
				let decoder = JSONDecoder()
				return try decoder.decode(T.self, from: jsonData)
		  } catch {
				throw FirestoreError.parseError
		  }
	 }

}
