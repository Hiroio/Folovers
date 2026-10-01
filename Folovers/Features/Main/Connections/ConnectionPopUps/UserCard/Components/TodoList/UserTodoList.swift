//
//  UserTodoList.swift
//  Folovers
//
//  Created by user on 02.09.2026.
//

import SwiftUI

struct UserTodoList: View {
  @Environment(\.theme) var theme
  let todos: [TodoItem]
  let state: UserTodoListState
    var body: some View {
		VStack{
		  Text("Today")
			 .font(.title2.weight(.semibold))
			 .frame(maxWidth: .infinity, alignment: .leading)
		  ZStack{
			 switch state{
			 case .open:
				ScrollView(showsIndicators: false){
				  LazyVStack(spacing: 15){
					 ForEach(todos){todo in
						UserTodoItem(todo: todo)
					 }
				  }
				}
			 case .empty, .closed:
				UserTodoStateCard(state: state)
			 }
		  }
		  .padding(25)
		}
		.fontDesign(.monospaced)
    }
}

#Preview {
  UserTodoList(todos: .todoItems, state: .open)
	 .environment(\.theme, .basic)
}
