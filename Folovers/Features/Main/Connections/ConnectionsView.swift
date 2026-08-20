//
//  ConnectionsView.swift
//  Folovers
//
//  Created by user on 20.08.2026.
//

import SwiftUI

struct ConnectionsView: View {
  @Environment(\.theme) var theme
    var body: some View {
		VStack{
		  ConnectionsHeader
		  
		  Text("Connections")
			 .font(.largeTitle)
			 .foregroundStyle(theme.primary)
			 .frame(maxHeight: .infinity)
		}
		.fontDesign(.monospaced)
    }
}

#Preview {
  ZStack{
	 ThemePalette.basic.background.ignoresSafeArea()
	 ConnectionsView()
		.environment(\.theme, .basic)
  }
}


extension ConnectionsView{
  private var ConnectionsHeader: some View{
	 HStack{
		VStack(alignment: .leading){
		  Text("Connections")
			 .font(.title2)
			 .foregroundStyle(theme.text)
		  Text("Your conenctions")
			 .font(.caption)
			 .foregroundStyle(theme.secondaryText)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		
		Image(systemName: "plus")
		  .font(.title2)
		  .foregroundStyle(theme.primaryDark)
	 }
  }
}
