//
//  TodosViewModel.swift
//  Folovers
//
//  Created by user on 01.09.2026.
//

import Foundation

@Observable
final class TodosViewModel{
  var creationSheetActive: Bool = false
  var todos: [TodoItem] {
	 manager.todos
  }
  var selectedDay: Date = .now
  var isEditing: Bool = false
  var itemToEdit: TodoItem? = nil
  
  
  private let manager = TodosManager.shared
  
  var selectedDayTodos: [TodoItem]{
	 print(self.todos)
	 let calendar = Calendar.current
	 
	 return todos.filter({ item in
		if let date = item.date{
		  return calendar.isDate(date, inSameDayAs: selectedDay)
		}else{
		  return item.date == nil && calendar.isDate(item.createdAt, inSameDayAs: selectedDay)
		}
	 }).sorted(by: { ($0.date ?? .distantFuture) < ($1.date ?? .distantFuture) })
  }
}


extension TodosViewModel{
  func completeTap(item: TodoItem){
	 var todo = item
	 todo.isDone = !todo.isDone
	 
	 manager.update(todo: todo)
  }
  
  
  func deleteTodo(item: TodoItem){
	 manager.delete(todo: item)
  }
}
