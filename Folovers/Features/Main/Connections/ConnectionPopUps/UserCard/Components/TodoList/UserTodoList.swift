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
    var body: some View {
		VStack{
		  Text("Today")
			 .font(.title2.weight(.semibold))
			 .frame(maxWidth: .infinity, alignment: .leading)
		  ZStack{
			 if todos.isEmpty{
				ScrollView(showsIndicators: false){
				  LazyVStack(spacing: 15){
					 ForEach(todos){todo in
						UserTodoItem(todo: todo)
					 }
				  }
				}
			 }else{
				Text("User don't have plans for today")
				  .font(.headline.weight(.bold))
				  .frame(maxWidth: .infinity, maxHeight: .infinity)
				  .foregroundStyle(theme.primaryDark)
				  .card()
			 }
		  }
		  .padding(25)
		}
		.fontDesign(.monospaced)
    }
}

#Preview {
  UserTodoList(todos: .todoItems)
	 .environment(\.theme, .basic)
}
