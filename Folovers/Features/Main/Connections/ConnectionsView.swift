//
//  ConnectionsView.swift
//  Folovers
//
//  Created by user on 20.08.2026.
//

import SwiftUI

struct ConnectionsView: View {
  @Environment(\.theme) var theme
  @State private var vm = ConnectionViewModel()
    var body: some View {
		VStack{
		  ConnectionsHeader
			 .padding(.bottom)
		  
		  ConnectionPicker(status: $vm.connectionsView)
		  
		  ConnectionSceneView(vm: vm)
		}
		.fontDesign(.monospaced)
		.padding()
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
