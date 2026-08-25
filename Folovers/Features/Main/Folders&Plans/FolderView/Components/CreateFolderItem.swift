//
//  CreateFolderItem.swift
//  Folovers
//
//  Created by user on 25.08.2026.
//

import SwiftUI

struct CreateFolderItem: View {
  @Environment(\.theme) var theme
  var body: some View {
	 VStack(spacing: 15){
		Text("Create Folder")
		  .font(.title2.weight(.bold))
		VStack(spacing: 15){
		  VStack{
			 Image("Folder")
				.resizable()
				.scaledToFit()
				.containerRelativeFrame(.horizontal, count: 2, spacing: 10)
		  }
		  .frame(maxWidth: .infinity)
		  .padding()
		  .overlay(
			 ZStack{
				RoundedRectangle(cornerRadius: 15)
				  .fill(theme.primary.opacity(0.2))
				Image(systemName: "plus")
				  .font(.title.weight(.semibold))
				
			 }
		  )
		  .border(dashed: true)
		  .padding()
		}
	 }
	 .foregroundStyle(theme.primaryDark)
	 .frame(maxWidth: .infinity)
	 .card(15, lineWidth: 4)
	 .fontDesign(.monospaced)
	 .padding()
  }
}

#Preview {
  CreateFolderItem()
	 .environment(\.theme, .basic)
}
