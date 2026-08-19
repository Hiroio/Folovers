//
//  StorageManager.swift
//  Folovers
//
//  Created by user on 18.08.2026.
//

import Foundation
import UIKit

final class StorageManager{


  private let fileManager = FMmanager()
  private let fireStorage = FireStorageManager.shared


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
	 await fireStorage.uploadPhotos(photos, folderId: folderId)
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
