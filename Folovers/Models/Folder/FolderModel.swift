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
  var folderColor: AppThemeColor
  var createdBy: String
  var createdAt: Date
}

extension FolderModel{
//  folderColor was added later, so folders created before it have no such key.
//  Without this they fail to decode with keyNotFound and disappear from the list
  init(from decoder: Decoder) throws {
	 let container = try decoder.container(keyedBy: CodingKeys.self)

	 self.id = try container.decode(String.self, forKey: .id)
	 self.members = try container.decode([String].self, forKey: .members)
	 self.title = try container.decode(String.self, forKey: .title)
	 self.subtitle = try container.decode(String.self, forKey: .subtitle)
	 self.folderColor = try container.decodeIfPresent(AppThemeColor.self, forKey: .folderColor) ?? .red
	 self.createdBy = try container.decode(String.self, forKey: .createdBy)
	 self.createdAt = try container.decode(Date.self, forKey: .createdAt)
  }
}

extension FolderModel{
  static func createPersonal(uid: String) -> FolderModel{
	 FolderModel(id: "", members: [uid], title: "Personal", subtitle: "Your personal folder", folderColor: .red, createdBy: "System", createdAt: .now)
  }
  
  static let personal = FolderModel(id: "", members: [], title: "Personal", subtitle: "Your personal folder", folderColor: .red, createdBy: "", createdAt: .now)
  static let personal2 = FolderModel(id: UUID().uuidString, members: [], title: "Personal2", subtitle: "Your personal folder", folderColor: .red, createdBy: "", createdAt: .now)
}
