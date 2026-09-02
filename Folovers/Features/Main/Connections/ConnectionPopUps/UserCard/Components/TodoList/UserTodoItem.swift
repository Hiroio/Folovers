//
//  UserTodoItem.swift
//  Folovers
//
//  Created by user on 02.09.2026.
//

import SwiftUI

struct UserTodoItem: View {
  @Environment(\.theme) var theme
  let todo: TodoItem
    var body: some View {
		HStack(alignment: .bottom){
		  HStack{
			 Circle()
				.fill(theme.primary)
				.frame(width: 5, alignment: .center)
			 Text(todo.title)
				.font(.footnote.weight(.bold))
				.lineLimit(1)
				.fixedSize(horizontal: true, vertical: false)
				.frame(maxWidth: .infinity)
				.foregroundStyle(theme.primaryDark)
		  }
		  StraightLine()
			 .stroke(theme.primaryDark, style: .init(lineWidth: 4, dash: [4, 5], dashPhase: 4))
			 .fixedSize(horizontal: false, vertical: true)
		  
			 Text((todo.date?.formatted(.dateTime.hour().minute())) ?? "Today")
			 .font(.caption.weight(.bold))
				.padding(5)
				.padding(.horizontal)
				.foregroundStyle(theme.surface)
				.background(
				  Capsule()
					 .fill(theme.primary)
				)
		}
		.fontDesign(.monospaced)
		.frame(maxWidth: .infinity, alignment: .bottom)
    }
}

#Preview {
  UserTodoItem(todo: .preview(id: "1"))
	 .environment(\.theme, .basic)
}
