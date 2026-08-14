//
//  LoadingView.swift
//  Folovers
//
//  Created by user on 11.08.2026.
//

import SwiftUI

struct LoadingView: View {
  @Environment(NavigationManager.self) var navigation
  @State private var step: Int = 0

  let state: StartNavigationFlow
    var body: some View {
		VStack(spacing: 0){
		  Spacer()
		  Image(systemName: "heart.fill")
			 .font(.largeTitle)
			 .foregroundStyle(.red)
			 .fontDesign(.monospaced)

		  GeometryReader { geo in
			 SpriteView(action: action, step: $step)
				.position(
				  x: action.xPosition(step: step, containerWidth: geo.size.width, spriteWidth: SpriteViewModel.displaySize.width),
				  y: 0
				)
				.animation(.easeInOut(duration: action.animationDuration), value: step)
		  }
		  .frame(maxWidth: .infinity)
		  .frame(height: 10)
		  Spacer()

		}
		.onAppear{
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
}

#Preview {
//  @Previewable @Namespace var previewNM
  LoadingView(state: .shortLoading)
	 .environment(NavigationManager.shared)
}
