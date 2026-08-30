//
//  FolderCreationViewModel.swift
//  Folovers
//
//  Created by user on 30.08.2026.
//

import Foundation


@Observable
final class FolderCreationViewModel{
  var title: String = ""
  var caption: String = ""
  var selectedConnections: [UserDocument] = []
  var selectedColor: AppThemeColor = ThemeManager.shared.selectedColor
  var connectionSheet: Bool = false
  
  
  private let folderManager = FolderManager.shared
  private let connectionManager = ConnectionManager.shared

//  Opened from a user card - that person is already in the folder
  init(preselected: UserDocument? = nil){
	 if let preselected{
		selectedConnections = [preselected]
	 }
  }


  var connections: [ConnectionModel] {
	 connectionManager.connections.filter({$0.status == .accepted})
  }

//  Profiles of everyone this user is connected with
  var connectionUsers: [UserDocument] {
	 let uid = AuthManager.shared.id

	 return connections.compactMap({ connection in
		guard let otherId = connection.users.first(where: { $0 != uid }) else { return nil }
		return connectionManager.profiles[otherId] ?? .placeholder(id: otherId)
	 })
  }

  var ableToCreate: Bool {
	 !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  func createFolder(){
	 guard let uid = AuthManager.shared.id, ableToCreate else { return }

//	 The owner has to be a member too, otherwise the arrayContains query skips this folder
	 let members = [uid] + selectedConnections.map(\.id)

	 let folder = FolderModel(
		id: "",
		members: members,
		title: title
		  .trimmingCharacters(
			 in: .whitespacesAndNewlines
		  ),
		subtitle: caption
		  .trimmingCharacters(
			 in: .whitespacesAndNewlines
		  ),
		folderColor: .red,
		createdBy: uid,
		createdAt: .now
	 )

	 folderManager.createFolder(folder: folder)
  }

  func removeConnection(_ user: UserDocument){
	 selectedConnections.removeAll(where: { $0.id == user.id })
  }
}
