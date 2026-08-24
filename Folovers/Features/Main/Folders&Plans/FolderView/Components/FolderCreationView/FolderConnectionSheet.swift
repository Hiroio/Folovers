//
//  FolderConnectionSheet.swift
//  Folovers
//
//  Created by user on 24.08.2026.
//

import SwiftUI
import SpritePackage

struct FolderConnectionSheet: View {
  @Environment(\.dismiss) var dismiss
  @Environment(\.theme) var theme
  let connections: [UserDocument]
  @Binding var selected: [UserDocument]
  @State private var sessionSelected: [UserDocument]
  @State private var searchText: String = ""

  init(connections: [UserDocument], selected: Binding<[UserDocument]>) {
	 self.connections = connections
	 self._selected = selected
	 self._sessionSelected = State(initialValue: selected.wrappedValue)
  }

  private var filteredConnections: [UserDocument] {
	 let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
	 guard !text.isEmpty else { return connections }

	 return connections.filter({ $0.displayName.localizedCaseInsensitiveContains(text) })
  }

  var body: some View {
	 VStack{
		sheetHeader
		  .padding(.bottom)

		TextField("", text: $searchText, prompt:
					  Text("Search by name...")
		  .foregroundStyle(theme.secondaryText)
		)
		.textFieldModifier()
		.border()

		ScrollView(showsIndicators: false){
		  ForEach(filteredConnections){item in
			 Button{
				selectConnection(connection: item)
			 }label: {
				connectionBarCard(user: item, selected: sessionSelected.contains(where: {$0.id == item.id}))
				  .padding(5)
			 }
		  }
		}
	 }
	 .fontDesign(.monospaced)
	 .padding()
  }

  private func selectConnection(connection: UserDocument){
	 if sessionSelected.contains(where: {$0.id == connection.id}){
		sessionSelected.removeAll(where: {$0.id == connection.id})
	 }else{
		sessionSelected.append(connection)
	 }
  }
}

#Preview {
  FolderConnectionSheet(connections: [], selected: .constant([]))
	 .environment(\.theme, .basic)
}

extension FolderConnectionSheet{
  private var sheetHeader: some View{
		Text("Connections")
		.font(.title3.weight(.bold))
		.frame(maxWidth: .infinity)
		.overlay(){
		  HStack{
			 Button{
				dismiss()
			 }label:{
				Image(systemName: "xmark")
				  .border(10)
			 }
			 
			 Spacer()
			 
			 Button{
				selected = sessionSelected
				dismiss()
			 }label:{
				Image(systemName: "checkmark")
				  .border(10)
			 }
		  }
		}
		.foregroundStyle(theme.primaryDark)
		.padding(.top)
  }
  
  
  func connectionBarCard(user: UserDocument, selected: Bool) -> some View{
	 HStack{
		SpriteView(action: .preview, config: user.characterConfig, size: CGSize(width: 45, height: 45))
		Text(user.displayName)
		  .font(.title3.weight(.semibold))
		  .frame(maxWidth: .infinity, alignment: .leading)
		Image(systemName: selected ? "checkmark.circle.fill" : "circle")
		  .font(.title2)
	 }
	 .foregroundStyle(theme.primary)
	 .border(10)
  }
}
