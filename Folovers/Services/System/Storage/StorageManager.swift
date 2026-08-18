//
//  StorageManager.swift
//  Folovers
//
//  Created by user on 18.08.2026.
//

import Foundation
import UIKit

final class StorageManager{


  private let fileManager = Filemanager()
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
}
