//
//  FoldersViewModel.swift
//  Folovers
//
//  Created by user on 14.08.2026.
//

import Foundation


@MainActor
@Observable
final class FoldersViewModel{
  var folders: [FolderModel] {
	 folderManager.folders
  }
  
  private let folderManager = FolderManager.shared
  
  
  var uid: String? {
	 AuthManager.shared.id
  }
}
//
//
//extension FoldersViewModel{
//  
//}
