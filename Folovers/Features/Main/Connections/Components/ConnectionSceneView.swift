//
//  ConnectionSceneView.swift
//  Folovers
//
//  Created by user on 21.08.2026.
//

import SwiftUI

struct ConnectionSceneView: View {
  @Environment(\.theme) var theme
  @Environment(ConnectionViewModel.self) var vm
    var body: some View {
		ZStack{
		  if let error = vm.connectionsError{
			 ConnectionsStateCard(state: .error(error: error))
		  }else{
			 switch vm.connectionsView {
			 case .accepted:
				ConnectionGridView(connections: vm.activeConnections, profiles: vm.profiles, state: .accepted)
				  .transition(.move(edge: .leading).combined(with: .opacity))
			 case .pending:
				ConnectionGridView(connections: vm.pendingConnections, profiles: vm.profiles, state: .pending)
				  .transition(.move(edge: .trailing).combined(with: .opacity))
			 }
		  }
		}
		.frame(maxHeight: .infinity)
    }
}

#Preview {
  ConnectionSceneView()
	 .environment(\.theme, .basic)
	 .environment(ConnectionViewModel())
}

