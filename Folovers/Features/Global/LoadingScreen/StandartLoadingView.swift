//
//  StandartLoadingView.swift
//  Folovers
//
//  Created by user on 11.08.2026.
//

import SwiftUI

struct StandartLoadingView: View {
  @Environment(\.theme) var theme
  @Environment(NavigationManager.self) var navigation
  @State private var progress: CGFloat = 0

  let state: StartNavigationFlow
  private let travelDuration: Double = 1.5
  private let characterSize: CGFloat = 64

  var body: some View {
	 GeometryReader { geo in
		let trackWidth = geo.size.width

		VStack(alignment: .leading, spacing: 0){
		  SpriteView(action: action, size: CGSize(width: characterSize, height: characterSize))
			 .frame(width: characterSize, height: characterSize, alignment: .leading)
			 .offset(x: progress * max(trackWidth - characterSize, 0))

		  ZStack(alignment: .leading){
			 RoundedRectangle(cornerRadius: 15)
				.fill(theme.primary)
				.frame(width: trackWidth * progress, height: 5)
		  }
		  .frame(maxWidth: .infinity, alignment: .leading)
		  .border(2, color: theme.primaryDark)
		}
		.frame(maxHeight: .infinity)
	 }
	 .padding(.horizontal)
	 .frame(maxWidth: .infinity, maxHeight: .infinity)
	 .onAppear{
		animateProgress()

		Task{
		  try? await Task.sleep(for: .seconds(3.5))
		  navigation.startLoading = true
		}
	 }
  }

  var action: SpriteActions{
	 if state == .longLoading{
		return .loading
	 }else{
		return .idleLoading
	 }
  }

  private func animateProgress(){
	 progress = 0
	 withAnimation(.linear(duration: travelDuration)){
		progress = 1
	 }
  }
}

#Preview {
  StandartLoadingView(state: .shortLoading)
	 .environment(NavigationManager.shared)
	 .environment(\.theme, .basic)
}
