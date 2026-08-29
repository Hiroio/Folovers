//
//  FolderCreationView.swift
//  Folovers
//
//  Created by user on 24.08.2026.
//

import SwiftUI

@Observable
final class FolderCreationViewModel{
  var title: String = ""
  var caption: String = ""
  var selectedConnections: [UserDocument] = []
  var connectionSheet: Bool = false
  
  
  private let folderManager = FolderManager.shared
  private let connectionManager = ConnectionManager.shared


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

struct FolderCreationView: View {
  @Environment(\.theme) var theme
  @State private var vm = FolderCreationViewModel()
  var body: some View {
	 VStack(spacing: 15){
		Text("Create Folder")
		  .font(.title2.weight(.bold))
		
		
		VStack(spacing: 15){
		  TextField("", text: $vm.title, prompt: Text("Folder Name").foregroundStyle(theme.secondaryText))
			 .textFieldModifier(light: true)
			 .border()
		  
		  
		  FolderConnectionsBar(selected: vm.selectedConnections, sheetIsActive: $vm.connectionSheet, onRemove: vm.removeConnection)
		  
		  VStack{
			 Image("Folder")
				.resizable()
				.scaledToFit()
				.containerRelativeFrame(.horizontal, count: 3, spacing: 10)
			 Text("Folder")
				.font(.title3.weight(.semibold))
		  }
		  .frame(maxWidth: .infinity)
		  .padding()
		  .background(
			 RoundedRectangle(cornerRadius: 15)
				.fill(theme.primary.opacity(0.2))
		  )
		  .border(dashed: true)
		  .padding()
		  
		  TextField("", text: $vm.caption, prompt: Text("Caption").font(.caption).foregroundStyle(theme.secondaryText), axis: .vertical)
			 .textFieldModifier()
			 .font(.caption)
		  
		  Button{
			 vm.createFolder()
			 NavigationManager.shared.popPopUp()
		  }label:{
			 Text("Create")
				.frame(maxWidth: .infinity)
				.border(15)
				.contentShape(.rect)
		  }
		  .buttonStyle(CustomAnimationForBtn(light: true))
		  .disabled(!vm.ableToCreate)
		}


	 }
	 .foregroundStyle(theme.primaryDark)
	 .frame(maxWidth: .infinity)
	 .card(15, lineWidth: 4)
	 .fontDesign(.monospaced)
	 .padding()
	 .sheet(isPresented: $vm.connectionSheet) {
		FolderConnectionSheet(connections: vm.connectionUsers, selected: $vm.selectedConnections)
		  .presentationDetents([.medium, .large])
	 }
  }
}

#Preview {
  FolderCreationView()
	 .environment(\.theme, .basic)
	 .padding(.horizontal)
}
