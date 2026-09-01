//
//  FolderConnectionsBar.swift
//  Folovers
//
//  Created by user on 24.08.2026.
//

import SwiftUI
import SpritePackage

struct FolderConnectionsBar: View {
  @Environment(\.theme) var theme
  let selected: [UserDocument]
  @Binding var sheetIsActive: Bool
  var onRemove: (UserDocument) -> Void
  let selectedColor: ThemePalette
    var body: some View {
		HStack{
		  if selected.isEmpty{
			 Text("Add Connections")
				.frame(maxWidth: .infinity)
				.contentShape(.rect)
				.onTapGesture {
				  sheetIsActive = true
				}
		  }else{
			 ScrollView(.horizontal, showsIndicators: false){
				HStack{
				  ForEach(selected){ item in
					 connectionCard(user: item)
				  }
				}
				.padding(1)
			 }
		  }
		  Button{
			 withAnimation{
				sheetIsActive = true
			 }
		  }label:{
			 Image(systemName: "plus")
				.border(10, color: selectedColor.primary)
		  }
		}
		.frame(maxWidth: .infinity)
		.foregroundStyle(selectedColor.primaryDark)
		.border(5, color: selectedColor.primary)
    }
}

#Preview {
  FolderConnectionsBar(selected: [.placeholder(id: "qwe"), .placeholder(id: "ewq"), .placeholder(id: "wqe"), .placeholder(id: "eqw")], sheetIsActive: .constant(false), onRemove: { _ in }, selectedColor: .basic)
	 .environment(\.theme, .basic)
}


extension FolderConnectionsBar{
  func connectionCard(user: UserDocument) -> some View{
	 HStack{
		SpriteView(action: .preview, config: user.characterConfig, size: CGSize(width: 32, height: 32))
		  .frame(height: 32)
		Text(user.displayName)
		  .font(.caption)
		Button{
		  withAnimation{
			 onRemove(user)
		  }
		}label:{
		  Image(systemName: "xmark")
		}
	 }
	 .border(5)
	 .foregroundStyle(theme.primaryDark)
  }
}
