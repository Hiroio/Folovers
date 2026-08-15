//
//  FolderItemView.swift
//  Folovers
//
//  Created by user on 14.08.2026.
//

import SwiftUI

struct FolderItemView: View {
  @Environment(\.theme) var theme
    var body: some View {
		VStack{
		  HStack{
			 Text("#2 items")
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
		  
		  VStack(spacing: 10){
			 Image("BlankCharacter")
				.resizable()
				.scaledToFit()
				.frame(width: 200, height: 220)
				.padding(.vertical)
			 Text("Personal")
				.font(.title.weight(.semibold))
				.foregroundStyle(theme.primaryDark)
			 
			 Text("Your personal folder")
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
	 FolderItemView()
		.environment(\.theme, .basic)
  }
}
