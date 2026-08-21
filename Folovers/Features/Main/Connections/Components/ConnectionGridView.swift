//
//  ConnectionGridView.swift
//  Folovers
//
//  Created by user on 21.08.2026.
//

import SwiftUI
import SpritePackage

struct ConnectionGridView: View {
  @Environment(\.theme) var theme
  let connections: [ConnectionModel]
  let profiles: [String: UserDocument]
  let state: ConnectionStatus
  var body: some View {
	 ZStack{
		if !connections.isEmpty{
		  ScrollView{
			 LazyVGrid(columns: Array(repeating: .init(.flexible()), count: state == .pending ? 1 : 3), spacing: 15){
				ForEach(connections){connection in
				  let id = connection.users.first(where: { $0 != AuthManager.shared.id })
				  if let id{
					 let user = profiles[id] ?? .placeholder(id: id)
					 ConnectionUserCard(user: user, date: connection.createdAt)
						.task{
						  await ConnectionManager.shared.loadProfileIfNeeded(uid: id)
						}
				  }
				}
			 }
		  }
		}else{
		  ConnectionsStateCard(state: state == .accepted ? .empty : .pendingEmpty)
		}
	 }
  }
}

#Preview {
  ZStack{
	 ThemePalette.basic.background.ignoresSafeArea()
	 ConnectionGridView(connections: [.conncetion(id: "qwe"), .conncetion(id: "ewq"), .conncetion(id: "aqwe"), .conncetion(id: "dewq"), .conncetion(id: "ewwq"), .conncetion(id: "aqwee"), .conncetion(id: "detwq")], profiles: [:], state: .pending)
		.environment(\.theme, .basic)
		.fontDesign(.monospaced)
  }
}


extension ConnectionGridView{
  func connectionAcceptedCard(user: UserDocument, date: Date) -> some View{
	 VStack{
		SpriteView(action: .preview, config: user.characterConfig)
		Text(user.displayName)
		  .font(.footnote)
		  .foregroundStyle(theme.primaryDark)
	 }
	 .card(10, lineWidth: 3, dashed: true)
  }
  
  func connectionPendingCard(user: UserDocument, date: Date) -> some View{
	 HStack{
		SpriteView(action: .preview, config: user.characterConfig)
		Text(user.displayName)
		  .font(.footnote)
		  .foregroundStyle(theme.primaryDark)
	 }
	 .frame(maxWidth: .infinity, alignment: .leading)
	 .card(10, lineWidth: 3, dashed: true)
  }
  
  @ViewBuilder
  func ConnectionUserCard(user: UserDocument, date: Date) -> some View{
	 switch state{
	 case .accepted:
		connectionAcceptedCard(user: user, date: date)
	 case .pending:
		connectionPendingCard(user: user, date: date)
	 }
  }
}
