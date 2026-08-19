//
//  FileManager.swift
//  Folovers
//
//  Created by user on 18.08.2026.
//

import Foundation
import SwiftUI

final class FMmanager{

  var appDirectory: URL?{
	 FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?.appendingPathComponent("Folovers")
  }

  private func ensureAppDirectoryExists() throws {
	 guard let appDirectory else { throw URLError(.cannotCreateFile) }
	 if !FileManager.default.fileExists(atPath: appDirectory.path){
		try FileManager.default.createDirectory(at: appDirectory, withIntermediateDirectories: true)
	 }
  }

  func saveImageInFm(image: UIImage, id: String) throws -> String{
	 guard let data = image.jpegData(compressionQuality: 0.7), let path = appDirectory?.appendingPathComponent(id) else{
		print("DEBUG: Failed to create jpegData")
		throw URLError(.cannotCreateFile)
	 }

	 try ensureAppDirectoryExists()
	 try data.write(to: path)
	 return path.path
  }
  
  func getFile(path: String) throws -> UIImage?{
	 guard checkIfExist(path: path) else { throw URLError(.fileDoesNotExist)}
	 
	 return UIImage(contentsOfFile: path)
  }
  
  func deleteImageFromFM(path: String) throws {
	 try FileManager.default.removeItem(atPath: path)
  }
  
  func checkIfExist(path: String) -> Bool {
	 FileManager.default.fileExists(atPath: path)
  }
}
