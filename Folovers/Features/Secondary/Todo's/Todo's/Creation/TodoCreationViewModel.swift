//
//  TodoCreationViewModel.swift
//  Folovers
//
//  Created by user on 01.09.2026.
//

import Foundation



@Observable
final class TodoCreationViewModel{
  var title: String = "" {
	 didSet{
		if title.count > 0{
		  getSimilarTodos()
		}
	 }
  }
  var similarTodos: [TodoItem] = []
  var note: String = ""
  var todoColor: AppThemeColor = ThemeManager.shared.selectedColor
  var privacy: TodoPrivacy = .public
  var date: Date? = nil
  
  private let manager = TodosManager.shared
  
  var id: String? {
	 AuthManager.shared.id
  }
}

extension TodoCreationViewModel{
  func createTodo(){
	 let todo = TodoItem(id: UUID().uuidString, title: title, note: note, date: date, privacy: privacy, isDone: false, colortheme: todoColor, createdAt: .now)
	 
	 Task{
		do{
		  try await manager.create(todo: todo)
		}catch{
		  
		}
	 }
  }
  
  
  func getPreset(todo: TodoItem){
	 title = todo.title
	 note = todo.note ?? ""
	 todoColor = todo.colortheme
	 privacy = todo.privacy
	 date = todo.date
  }
  
  func getSimilarTodos(){
	 let query = title.trimmingCharacters(in: .whitespacesAndNewlines)
	 self.similarTodos = manager.todos.filter({ $0.title.localizedCaseInsensitiveContains(query)})
  }
}
