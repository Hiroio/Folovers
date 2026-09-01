//
//  FoldersView.swift
//  Folovers
//
//  Created by user on 14.08.2026.
//

import SwiftUI

struct FoldersView: View {
  @Environment(\.theme) var theme
  @State private var vm = FoldersViewModel()
    var body: some View {
		VStack{
		  FoldersHeader
		  
		  FolderSliderView(folders: vm.folders)
			 .frame(maxWidth: .infinity)
			
		  
		}
		.padding()
		.fontDesign(.monospaced)
		
    }
}

#Preview {
    FoldersView()
	 .environment(\.theme, .basic)
}

extension FoldersView{
  private var FoldersHeader: some View{
	 HStack{
		VStack(alignment: .leading){
		  Text("Folders")
			 .font(.title2)
			 .foregroundStyle(theme.text)
		  Text("Your plans & memories")
			 .font(.caption)
			 .foregroundStyle(theme.secondaryText)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		
		Button{
		  withAnimation{
			 NavigationManager.shared.addPopUp(.folderCreation(with: nil))
		  }
		}label: {
		  Image(systemName: "plus")
			 .font(.title2)
			 .foregroundStyle(theme.primaryDark)
		}
	 }
  }
  
}
