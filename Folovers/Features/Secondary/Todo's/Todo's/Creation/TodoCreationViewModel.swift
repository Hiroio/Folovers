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

  let isEditing: Bool
//  Kept aside so an update can carry over id/isDone/createdAt and the fields
//  are only copied into the form after init - see loadOriginTodo()
  private let originTodo: TodoItem?

  private let manager = TodosManager.shared

  var id: String? {
	 AuthManager.shared.id
  }

  init(todo: TodoItem? = nil){
	 self.originTodo = todo
	 self.isEditing = todo != nil
  }

  var actionBtnName: String{
	 isEditing ? "Edit" : "Create"
  }
}


// MARK: ---------- -=| Creating || Editing |=- ---------------------
extension TodoCreationViewModel{
  func submitAction(){
	 if isEditing{
		updateTodo()
	 }else{
		createTodo()
	 }
  }

  func createTodo(){
	 let todo = TodoItem(id: UUID().uuidString, title: title, note: note, date: date, privacy: privacy, isDone: false, colortheme: todoColor, createdAt: .now)

	 Task{
		do{
		  try await manager.create(todo: todo)
		}catch{

		}
	 }
  }

  func updateTodo(){
	 guard var todoToUpdate = originTodo else { return }

	 todoToUpdate.title = title
	 todoToUpdate.note = note
	 todoToUpdate.date = date
	 todoToUpdate.privacy = privacy
	 todoToUpdate.colortheme = todoColor

	 manager.update(todo: todoToUpdate)
  }

//  Called once the view has appeared, so the fields animate from empty into
//  place instead of showing already filled
  func loadOriginTodo(){
	 guard let originTodo else { return }
	 getPreset(todo: originTodo)
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
