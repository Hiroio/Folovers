//
//  FireStorageManager.swift
//  Folovers
//
//  Created by user on 11.08.2026.
//

import Foundation
import FirebaseStorage


@Observable
final class FireStorageManager{
  static let shared = FireStorageManager()
  
  let storage: Storage
  
  
  init(){
	 self.storage = Storage.storage(url: "gs://folovers.firebasestorage.app")
  }
}
