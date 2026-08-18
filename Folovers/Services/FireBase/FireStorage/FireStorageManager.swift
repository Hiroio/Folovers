//
//  FireStorageManager.swift
//  Folovers
//
//  Created by user on 11.08.2026.
//

import Foundation
import FirebaseStorage


final class FireStorageManager{
  static let shared = FireStorageManager()

  let storage: Storage
  let storageRef: StorageReference

  init(){
	 let storage = Storage.storage(url: "gs://folovers.firebasestorage.app")
	 self.storage = storage
	 self.storageRef = storage.reference()
  }
}

extension FireStorageManager{
  func uploadFile(photo: PhotoAttachment, folderId: String) async throws -> PhotoAttachment {
	 guard let path = photo.localPath else { throw URLError(.badURL) }
	 let localFile = URL(fileURLWithPath: path)

	 let photoRef = storageRef.child("images/\(folderId)/\(photo.id).jpg")

	 let uploadTask = try await photoRef.putFileAsync(from: localFile)

	 let downloadUrl = try await photoRef.downloadURL()
	 var photoWithUrl = PhotoAttachment(
		id: photo.id,
		localPath: path,
		remoteUrl: downloadUrl.absoluteString,
		thumbnailUrl: downloadUrl.absoluteString,
		status: .uploaded,
		uploadedBy: photo.uploadedBy
	 )

	 return photoWithUrl
  }

  func deleteFile(photo: PhotoAttachment, folderId: String) async throws {

	 let photoRef = storageRef.child("images/\(folderId)/\(photo.id).jpg")

	 try await photoRef.delete()
  }

}

extension FireStorageManager{
  func uploadPhotos(_ photos: [PhotoAttachment], folderId: String) async -> [PhotoAttachment] {
	 var results: [PhotoAttachment] = []

	 for photo in photos{
		guard photo.status != .uploaded else{
		  results.append(photo)
		  continue
		}

		do{
		  let uploaded = try await uploadFile(photo: photo, folderId: folderId)
		  results.append(uploaded)
		}catch{
		  print("DEBUG: Failed to upload photo \(photo.id): \(error)")
		  var failedPhoto = photo
		  failedPhoto.status = .failed
		  results.append(failedPhoto)
		}
	 }

	 return results
  }
}
