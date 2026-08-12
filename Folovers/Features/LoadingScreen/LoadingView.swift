//
//  LoadingView.swift
//  Folovers
//
//  Created by user on 11.08.2026.
//

import SwiftUI

struct LoadingView: View {
  @Environment(NavigationManager.self) var navigation
  
  let state: StartNavigationFlow
    var body: some View {
		VStack(spacing: 0){
		  if state == .shortLoading {
			 Button{
				AuthManager.shared.logOut()
			 }label: {
				Text("Log out")
				  .foregroundStyle(.red)
			 }
		  }
		  Spacer()
		  Image(systemName: "heart.fill")
			 .font(.largeTitle)
			 .foregroundStyle(.red)
			 .fontDesign(.monospaced)
		  
		  
		  SpriteView(action: action)
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
