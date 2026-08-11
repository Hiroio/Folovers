//
//  LoadingView.swift
//  Folovers
//
//  Created by user on 11.08.2026.
//

import SwiftUI

struct LoadingView: View {
  
    var body: some View {
		ZStack(){
		  Image(systemName: "heart.fill")
			 .imageScale(.large)
			 .foregroundStyle(.red)
			 .fontDesign(.monospaced)
		  SpriteView(action: .loading)
			 .frame(maxWidth: .infinity)
			 .frame(height: 150)
		}
    }
}

#Preview {
    LoadingView()
}
