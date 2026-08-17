//
//  FolderModel.swift
//  Folovers
//
//  Created by user on 16.08.2026.
//

import Foundation


struct FolderModel: FirestoreIdentifiable{
  var id: String
  var members: [String]
  var title: String
  var subtitle: String
  var createdBy: String
  var createdAt: Date
}

extension FolderModel{
  static let personal = FolderModel(id: "", members: [], title: "Personal", subtitle: "Your personal folder", createdBy: "", createdAt: .now)
  static let personal2 = FolderModel(id: UUID().uuidString, members: [], title: "Personal2", subtitle: "Your personal folder", createdBy: "", createdAt: .now)
}
