//
//  StorageManager.swift
//  Folovers
//
//  Created by user on 18.08.2026.
//

import Foundation
import UIKit

final class StorageManager{
  static let shared = StorageManager()
  
  private let fileManager = FMmanager()
  private let fireStorage = FireStorageManager.shared
  private let planManager = PlanManager()
  
  private var backgroundTask: Task<Void, Never>? = nil
  
}

extension StorageManager{
  func createAttachments(from images: [UIImage]) -> [PhotoAttachment] {
	 guard let uid = AuthManager.shared.id else { return [] }
	 
	 var attachments: [PhotoAttachment] = []
	 
	 for image in images{
		let id = UUID().uuidString
		do{
		  let path = try fileManager.saveImageInFm(image: image, id: id)
		  let attachment = PhotoAttachment(
			 id: id,
			 localPath: path,
			 remoteUrl: nil,
			 thumbnailUrl: nil,
			 status: .pending,
			 uploadedBy: uid
		  )
		  attachments.append(attachment)
		}catch{
		  print("DEBUG: Failed to save photo locally: \(error)")
		}
	 }
	 
	 return attachments
  }
  
  func uploadPhotos(_ photos: [PhotoAttachment], folderId: String) async -> [PhotoAttachment] {
	 let toUpload = photos.filter({
		if let path = $0.localPath{
		  return fileManager.checkIfExist(path: path)
		}
		return false
	 })
	 guard !toUpload.isEmpty else { return [] }
	 
	 
	 let uploaded = await fireStorage.uploadPhotos(toUpload, folderId: folderId)
	 
	 return uploaded.map{ photo in
		guard photo.status == .uploaded else {return photo}
		
		guard let localPath = photo.localPath else {
		  return photo
		}
		
		if fileManager.checkIfExist(path: localPath){
		  do{
			 try fileManager.deleteImageFromFM(path: localPath)
		  }catch{
			 print("DEBUG: Failed to delete local photo after upload: \(error)")
		  }
		}
		
		var cleaned = photo
		cleaned.localPath = nil
		return cleaned
	 }
  }
}

extension StorageManager{
  func reconcilePhotos(original: [PhotoAttachment], current: [PhotoAttachment], newImages: [UIImage], folderId: String) async -> [PhotoAttachment] {
	 
	 let currentIds = Set(current.map(\.id))
	 let removed = original.filter{ !currentIds.contains($0.id) }
	 
	 for photo in removed{
		await deletePhoto(photo, folderId: folderId)
	 }
	 
	 guard !newImages.isEmpty else { return current }
	 
	 let newAttachments = createAttachments(from: newImages)
	 let uploaded = await uploadPhotos(newAttachments, folderId: folderId)
	 
	 return current + uploaded
  }
  
  private func deletePhoto(_ photo: PhotoAttachment, folderId: String) async {
	 if photo.remoteUrl != nil{
		do{
		  try await fireStorage.deleteFile(photo: photo, folderId: folderId)
		}catch{
		  print("DEBUG: Failed to delete photo from storage: \(error)")
		}
	 }
	 
	 if let localPath = photo.localPath, fileManager.checkIfExist(path: localPath){
		do{
		  try fileManager.deleteImageFromFM(path: localPath)
		}catch{
		  print("DEBUG: Failed to delete local photo: \(error)")
		}
	 }
  }
}


extension StorageManager{
  func startReloadingTask(plans: [PlanCard]) {
	 guard backgroundTask == nil else { return }
	 
	 backgroundTask = Task(priority: .background){
		defer {backgroundTask = nil}
		await reloadingImages(plans: plans)
	 }
  }
  
  func reloadingImages(plans: [PlanCard]) async {
	 for plan in plans{
		let photosToUpload = plan.photos.filter({ $0.localPath != nil && $0.status == .failed})
		var newPhotos: [PhotoAttachment] = plan.photos.filter({ $0.status == .uploaded })
		
		let newUploadedPhotos = await uploadPhotos(photosToUpload, folderId: plan.folderId)
		if !newUploadedPhotos.isEmpty{
		  newPhotos.append(contentsOf: newUploadedPhotos)
		}
		
		var planToUpdate = plan
		planToUpdate.photos = newPhotos
		if planToUpdate.photos.sorted(by: {$0.id < $1.id}) != plan.photos.sorted(by: {$0.id < $1.id}){
			try? await planManager.updatePlan(planToUpdate)
		}
	 }
	 
  }
}
