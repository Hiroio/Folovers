//
//  PlanCard.swift
//  Folovers
//
//  Created by user on 15.08.2026.
//

import Foundation


struct PlanCard: FirestoreIdentifiable {
  var id: String
  var folderId: String        // = uid для personal, = spaceId для shared
  var title: String
  var note: String?
  var date: Date?
  var location: String?       // опціонально, поки просто рядок; географічні координати — пізніше
  var photos: [PhotoAttachment]
  var isCompleted: Bool
  var createdBy: String
  var createdAt: Date
}


extension PlanCard{
  init(folderId: String, createdBy: String){
	 self.id = ""
	 self.folderId = folderId
	 self.title = ""
	 self.note = ""
	 self.photos = []
	 self.isCompleted = false
	 self.createdBy = createdBy
	 self.createdAt = .now
  }
  
  
  static func plans() -> [PlanCard]{
	 let planstitles: [String] = ["Some plan to traver", "Some food to try", "Some places to visit", "Some people to meet"]
	 return planstitles.map({PlanCard(id: UUID().uuidString, folderId: "", title: $0, photos: [], isCompleted: false, createdBy: "", createdAt: .now)})
  }
}



struct PhotoAttachment: Codable {
  let id: String
  var localPath: String?
  var remoteUrl: String?
  var thumbnailUrl: String?
  var status: UploadStatus
  var uploadedBy: String
}


enum UploadStatus: String, Codable {
  case pending
  case uploading
  case uploaded
  case failed
}
