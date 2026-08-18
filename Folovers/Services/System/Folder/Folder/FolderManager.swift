//
//  FolderManager.swift
//  Folovers
//
//  Created by user on 16.08.2026.
//

import Foundation


@MainActor
@Observable
final class FolderManager{
  static let shared = FolderManager()
  var folders: [FolderModel] = []
  var error: FirestoreError? = nil
  
  
  init(){
	 fetchAllRelated()
  }
  
  var uid: String? {
	 AuthManager.shared.id
  }
  
  func mapError(error: Error){
	 if let error = error as? FirestoreError{
		self.error = error
	 }else{
		self.error = .unknownError
	 }
  }
}

extension FolderManager{
  
  func fetchAllRelated() {
	 guard let uid else { return }
	 let endpoint = FolderEndpoint(action: .fetchAll(userId: uid))
	 
	 Task{
		do{
		  let fetchedFolders: [FolderModel] = try await FirestoreService.request(endpoint)
		  self.folders = fetchedFolders
		}catch{
		  mapError(error: error)
		}
	 }
  }
  
  
  func createFolder(folder: FolderModel){
	 guard let uid else { return }
	 var folderCopy = folder
	 folderCopy.createdBy = uid
	 let endpoint = FolderEndpoint(action: .create(folderCopy))
	 
	 Task{
		do{
		  try await FirestoreService.request(endpoint)
		}catch{
		  mapError(error: error)
		}
	 }
  }
  
  
  func updateFolder(folder: FolderModel){
	 let endPoint = FolderEndpoint(action: .update(folder))
	 
	 Task{
		do{
		  try await FirestoreService.request(endPoint)
		}catch{
		  mapError(error: error)
		}
	 }
  }
  
  func deleteFolder(folder: FolderModel){
	 let endPoint = FolderEndpoint(action: .delete(folder))
	 
	 Task{
		do{
		  try await FirestoreService.request(endPoint)
		}catch{
		  mapError(error: error)
		}
	 }
  }
}
