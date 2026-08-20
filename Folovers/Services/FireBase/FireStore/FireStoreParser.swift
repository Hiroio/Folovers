//
//  FireStoreParser.swift
//  Folovers
//
//  Created by user on 11.08.2026.
//

import Foundation
import FirebaseFirestore

struct FirestoreParser {

  static func parse<T: FirestoreIdentifiable>(_ documentData: Dictionary<String, Any>, type: T.Type) throws -> T {
		  do {
				let jsonData = try JSONSerialization.data(withJSONObject: sanitize(documentData), options: [])
				let decoder = JSONDecoder()
				return try decoder.decode(T.self, from: jsonData)
		  } catch {
				print("DEBUG: Failed to parse \(T.self): \(error)")
				throw FirestoreError.parseError
		  }
	 }

//	 Firestore hands back Timestamp objects, which JSONSerialization can not write.
//	 JSONEncoder stores Date as timeIntervalSinceReferenceDate, so match that here.
  private static func sanitize(_ value: Any) -> Any {
	 switch value {
	 case let timestamp as Timestamp:
		return timestamp.dateValue().timeIntervalSinceReferenceDate
	 case let dictionary as [String: Any]:
		return dictionary.mapValues({ sanitize($0) })
	 case let array as [Any]:
		return array.map({ sanitize($0) })
	 default:
		return value
	 }
  }

}
