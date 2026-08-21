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
		  
		  Text("Hello there")
			 .font(.largeTitle)
			 .foregroundStyle(theme.primary)
			 .frame(maxHeight: .infinity)
		}
		.padding()
		.fontDesign(.monospaced)
    }
}

#Preview {
    HomeView()
	 .environment(\.theme, .basic)
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
