//
//  HomeView.swift
//  Folovers
//
//  Created by user on 20.08.2026.
//

import SwiftUI

struct HomeView: View {
  @Environment(\.theme) var theme
  @State private var vm = HomeViewModel()
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
		  Button{
			 NavigationManager.shared.addPopUp(.mailBox)
		  }label:{
			 let image = vm.unReadMessages > 0 ? "EnvelopeSealed" : "EnvelopeOpen"
			 Image(image)
				.resizable()
				.scaledToFit()
				.containerRelativeFrame(.horizontal, count: 4, spacing: 30)
				.overlay(alignment: .topLeading){
				  Text("\(vm.unReadMessages)")
					 .foregroundStyle(.white)
					 .font(.headline.weight(.bold))
					 .padding(8)
					 .background(
						Circle()
						  .fill(theme.primary)
					 )
					 .opacity(vm.unReadMessages > 0 ? 1 : 0)
					 .offset(x: -1, y: -10)
				}
		  }
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
