//
//  FireStoreError.swift
//  Folovers
//
//  Created by user on 11.08.2026.
//

import Foundation


import Foundation

public enum FirestoreError: Error {
	 case invalidPath
	 case invalidType
	 case collectionNotFound
	 case documentNotFound
	 case unknownError
	 case parseError
	 case invalidRequest
	 case operationNotSupported
	 case invalidQuery
	 case operationNotAllowed
}
