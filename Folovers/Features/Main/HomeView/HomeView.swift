//
//  HomeView.swift
//  Folovers
//
//  Created by user on 20.08.2026.
//

import SwiftUI

struct HomeView: View {
  @Environment(\.theme) var theme
    var body: some View {
		VStack{
		  HomeHeader
		  
		  VStack{
			 Text("Hello there")
				.font(.largeTitle.weight(.bold))
				.foregroundStyle(theme.primaryDark)
			 
			 SpriteView(action: .idle, size: CGSize(width: 128, height: 128))
		  }
		  .frame(maxHeight: .infinity, alignment: .top)
		}
		.frame(maxHeight: .infinity)
		.overlay(alignment: .bottomTrailing){
		  Image("EnvelopeSealed")
			 .resizable()
			 .scaledToFit()
			 .containerRelativeFrame(.horizontal, count: 4, spacing: 30)
		}
		.padding()
		.fontDesign(.monospaced)
    }
}

#Preview {
  ZStack{
	 ThemePalette.basic.background.ignoresSafeArea()
	 HomeView()
		.environment(\.theme, .basic)
  }
}

extension HomeView{
  private var HomeHeader: some View{
	 HStack{
		VStack(alignment: .leading){
		  Text("Home")
			 .font(.title2)
			 .foregroundStyle(theme.text)
		  Text("your home page")
			 .font(.caption)
			 .foregroundStyle(theme.secondaryText)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
	 }
  }
}
