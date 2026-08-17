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
		GeometryReader { geo in
		  VStack(spacing: 0){
			 Spacer()
			 Image(systemName: "heart.fill")
				.font(.largeTitle)
				.foregroundStyle(.red)
				.fontDesign(.monospaced)
			 
			 
			 SpriteView(action: action, step: $step)
				.position(
				  x: action.xPosition(step: step, containerWidth: geo.size.width, spriteWidth: SpriteViewModel.displaySize.width)
				)
				.animation(.easeInOut(duration: action.animationDuration), value: step)
			 
			 Spacer()
		  }
		  .frame(maxHeight: .infinity)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
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
