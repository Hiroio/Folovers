//
//  FolderCreationView.swift
//  Folovers
//
//  Created by user on 24.08.2026.
//

import SwiftUI

struct FolderCreationView: View {
  @Environment(\.theme) var theme
  @State private var vm: FolderCreationViewModel

  init(preselected: UserDocument? = nil){
	 self._vm = State(wrappedValue: FolderCreationViewModel(preselected: preselected))
  }
  var body: some View {
	 VStack(spacing: 15){
		Text("Create Folder")
		  .font(.title2.weight(.bold))
		
		
		VStack(spacing: 15){

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
				.fill(vm.selectedColor.palette.primary.opacity(0.2))
		  )
		  .border(dashed: true, color: vm.selectedColor.palette.primary)
		  .padding()
		  
		  
		  FolderConnectionsBar(selected: vm.selectedConnections, sheetIsActive: $vm.connectionSheet, onRemove: vm.removeConnection, selectedColor: vm.selectedColor.palette)
		  
		  
		  TextField("", text: $vm.title, prompt: Text("Folder Name").foregroundStyle(theme.secondaryText))
			 .textFieldModifier(light: true)
			 .border(color: vm.selectedColor.palette.primary)
		  
		  
		  
		  
		  TextField("", text: $vm.caption, prompt: Text("Caption").font(.caption).foregroundStyle(theme.secondaryText), axis: .vertical)
			 .textFieldModifier()
			 .font(.caption)
		  
		  ColorSelectionBar(color: $vm.selectedColor)
		  
		  Button{
			 vm.createFolder()
			 NavigationManager.shared.popPopUp()
		  }label:{
			 Text("Create")
				.frame(maxWidth: .infinity)
				.border(15, color: vm.selectedColor.palette.primary)
				.contentShape(.rect)
		  }
		  .buttonStyle(CustomAnimationForBtn(light: true))
		  .disabled(!vm.ableToCreate)
		}


	 }
	 .foregroundStyle(vm.selectedColor.palette.primaryDark)
	 .frame(maxWidth: .infinity)
	 .card(15, lineWidth: 4, palette: vm.selectedColor.palette)
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
