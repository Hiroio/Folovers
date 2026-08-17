//
//  FolderItemView.swift
//  Folovers
//
//  Created by user on 14.08.2026.
//

import SwiftUI

struct FolderItemView: View {
  @Environment(\.theme) var theme
  let folder: FolderModel
  var body: some View {
	 VStack{
		folderCardHeader
		
		VStack(spacing: 10){
		  Image("BlankCharacter")
			 .resizable()
			 .scaledToFit()
			 .frame(width: 200, height: 220)
			 .padding(.vertical)
		  Text(folder.title)
			 .font(.title.weight(.semibold))
			 .foregroundStyle(theme.primaryDark)
		  
		  Text(folder.subtitle)
			 .font(.subheadline)
			 .foregroundStyle(theme.secondaryText)
		}
	 }
	 .fontDesign(.monospaced)
	 .padding()
	 .card(lineWidth: 3)
	 .padding()
  }
}

#Preview {
  ZStack{
	 AppThemeColor.red.palette.background.ignoresSafeArea()
	 FolderItemView(folder: .personal)
		.environment(\.theme, .basic)
  }
}




extension FolderItemView{
  private var folderCardHeader: some View{
	 HStack{
		HStack{
		  Image(systemName: "person")
		  Text("\(folder.members.count)")
		}
		.border(12)
		.background(
		  RoundedRectangle(cornerRadius: 15)
			 .fill(.white.opacity(0.3))
		)
		
		.frame(maxWidth: .infinity, alignment: .leading)
		
		Text(Date.now.formatted(.dateTime.year().month()))
	 }
	 .foregroundStyle(theme.primary)
	 .font(.subheadline.weight(.semibold))
  }
}
