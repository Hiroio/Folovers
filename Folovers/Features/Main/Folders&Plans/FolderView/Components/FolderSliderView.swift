//
//  FolderSliderView.swift
//  Folovers
//
//  Created by user on 16.08.2026.
//

import SwiftUI

struct FolderSliderView: View {
  let folders: [FolderModel]
  @State private var activeID: String?

  private var activeIndex: Int {
	 folders.firstIndex(where: { $0.id == activeID }) ?? 0
  }

  var body: some View {
	 ScrollView(.horizontal){
		LazyHStack{
		  ForEach(folders) {folder in
			 Button{
				withAnimation(.easeInOut){
				  NavigationManager.shared.secondaryView.append(.plans(folder: folder))
				}
			 }label: {
				FolderItemView(folder: folder)
				  .id(folder.id)
				  .containerRelativeFrame(.horizontal, count: 1, spacing: 20)
			 }
		  }
		  
		  Button{
			 withAnimation {
				NavigationManager.shared.addPopUp(.folderCreation)
			 }
		  }label: {
			 CreateFolderItem()
				.containerRelativeFrame(.horizontal, count: 1, spacing: 20)
		  }
		}
		.scrollTargetLayout()
	 }
	 .scrollTargetBehavior(.viewAligned)
	 .scrollPosition(id: $activeID)
	 .scrollIndicators(.hidden)
	 .safeAreaPadding(.horizontal, 10)
	 .overlay(alignment: .bottom){
		WindowedPageIndicator(count: folders.count, activeIndex: activeIndex)
	 }
  }
}

private struct WindowedPageIndicator: View {
  @Environment(\.theme) var theme
  let count: Int
  let activeIndex: Int
  var windowSize: Int = 3

  private var windowStart: Int {
	 guard count > windowSize else { return 0 }
	 let lookahead = windowSize - 2
	 return min(max(activeIndex - lookahead, 0), count - windowSize)
  }

  private var windowRange: Range<Int> {
	 windowStart..<min(windowStart + windowSize, count)
  }

  var body: some View {
	 HStack(spacing: 10){
		ForEach(windowRange, id: \.self) { index in
		  if index == activeIndex {
			 Image(systemName: "heart.fill")
				.foregroundStyle(theme.primary)
				.transition(.scale.combined(with: .opacity))
		  } else {
			 Circle()
				.fill(theme.secondaryText)
				.frame(width: 6, height: 6)
				.transition(.scale.combined(with: .opacity))
		  }
		}
	 }
	 .animation(.easeInOut(duration: 0.25), value: activeIndex)
	 .padding(.bottom, 8)
  }
}

#Preview {
  FolderSliderView(folders: [.personal, .personal2])
}
