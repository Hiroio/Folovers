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
  var date: Date?        // опціонально — не календар
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
}
