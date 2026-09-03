//
//  TodoItemView.swift
//  Folovers
//
//  Created by user on 01.09.2026.
//

import SwiftUI

struct TodoItemView: View {
  @State private var extended: Bool = false
  let todoItem: TodoItem
  let isEditing: Bool
  let onComplete: () -> ()
  let onEdit: () -> ()
  let onDelete: () -> ()
    var body: some View {
		HStack(alignment: .bottom){
		  let color = todoItem.colortheme.palette
		  HStack(alignment: .center){
			 if todoItem.privacy == .private{
				Image(systemName: "lock.fill")
				  .font(.caption)
				  .foregroundStyle(color.secondaryText)
			 }
				if false{
				  Text(Date.now.formatted(.dateTime.hour().minute()))
					 .font(.footnote.weight(.semibold))
					 .card(5, palette: color)
					 .fixedSize(horizontal: true, vertical: true)
				}else{
				  RoundedRectangle(cornerRadius: 15)
					 .fill(color.surface)
					 .frame(width: 30,height: 15)
				}
			 
			 VStack(alignment: .leading){
				Button{
				  withAnimation{
					 extended.toggle()
				  }
				}label:{
				  HStack(alignment: .bottom){
					 Text(todoItem.title)
						.font(.subheadline.weight(.semibold))
						.lineLimit(extended ? nil : 1)
						.fixedSize(horizontal: true, vertical: false)
					 
					 if todoItem.note != nil{
						Image(systemName: "chevron.right")
						  .rotationEffect(Angle(degrees: extended ? 90 : 0))
					 }
				  }
				  .foregroundStyle(todoItem.colortheme.palette.primaryDark)
				}
				
				if extended{
				  Text(todoItem.note ?? "")
					 .font(.footnote)
					 .foregroundStyle(color.secondaryText)
					 .fixedSize(horizontal: true, vertical: false)
				}
			 }
		  }
		  
		  StraightLine()
			 .stroke(color.primaryDark, style: .init(lineWidth: 4, dash: [4, 5], dashPhase: 4))
			 .fixedSize(horizontal: false, vertical: true)
			 
			 
		  if isEditing{
			 HStack(spacing: 20){
				Button{
				  onEdit()
				}label:{
				  Image(systemName: "pencil")
					 .foregroundStyle(color.primary)
				}
				Button{
				  NavigationManager.shared.confirm("Delete \"\(todoItem.title)\"?"){
					 onDelete()
				  }
				}label:{
				  Image(systemName: "trash")
					 .foregroundStyle(.red)
				}
			 }
			 .font(.title3.weight(.semibold))
			 .transition(.scale)
			 .padding(.vertical, 5)
		  }else{
			 Button{
				onComplete()
			 }label:{
				Image(systemName: todoItem.isDone ? "checkmark.circle.fill" : "circle")
				  .font(.title)
				  .foregroundStyle(todoItem.colortheme.palette.primary)
				  .offset(x: -5)
			 }
			 .transition(.scale)
			 .disabled(isEditing)
		  }
		}
		.frame(maxHeight: .infinity, alignment: .bottom)
		.fontDesign(.monospaced)
    }
}

#Preview {
  TodoItemView(todoItem: .preview(id: "412"), isEditing: true, onComplete: {}, onEdit: {}, onDelete: {})
}
