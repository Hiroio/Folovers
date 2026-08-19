//
//  PlanCard.swift
//  Folovers
//
//  Created by user on 15.08.2026.
//

import Foundation


struct PlanCard: FirestoreIdentifiable {
  var id: String
  var folderId: String       
  var title: String
  var note: String?
  var date: Date?
  var location: PlanLocation?
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



struct PhotoAttachment: Codable, Equatable {
  let id: String
  var localPath: String?
  var remoteUrl: String?
  var thumbnailUrl: String?
  var status: UploadStatus
  var uploadedBy: String
}

extension PhotoAttachment{
  static func example() -> [PhotoAttachment]{
	 (0...5).map({PhotoAttachment(id: UUID().uuidString, localPath: "", remoteUrl: "https://picsum.photos/id/\(237 + $0)/200/300", thumbnailUrl: "", status: .uploaded, uploadedBy: "") })
  }
}


enum UploadStatus: String, Codable {
  case pending
  case uploading
  case uploaded
  case failed
}


struct PlanLocation: Codable, Equatable {
  var name: String
  var latitude: Double
  var longitude: Double
}
