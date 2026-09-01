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
  
  private let manager = TodosManager.shared
  
  var selectedDayTodos: [TodoItem]{
	 let calendar = Calendar.current
	 
	 return todos.filter({ calendar.isDate($0.createdAt, inSameDayAs: selectedDay)})
  }
}


extension TodosViewModel{
  
}
