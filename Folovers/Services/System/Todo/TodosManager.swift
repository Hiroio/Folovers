//
//  TodosManager.swift
//  Folovers
//
//  Created by user on 01.09.2026.
//

import Foundation


@Observable
final class TodosManager{
  static let shared = TodosManager()
  
  var todos: [TodoItem] = []
  
  
  var id: String?{
	 AuthManager.shared.id
  }
}


extension TodosManager{
  func getTodos(){
	 guard let id else {return}
	 
	 let endpoint = TodoEndpoint.getTodos(uid: id)
	 
	 Task{
		do{
		  let todos: [TodoItem] = try await FirestoreService.request(endpoint)
		  self.todos = todos
		}catch{
		  print("DEBUG")
		}
	 }
  }
  
  func getUserTodos(userId: String) async throws -> [TodoItem]{
	 let endpoint = TodoEndpoint.getUserTodaysTodos(userId: userId)
	 
	 return try await FirestoreService.request(endpoint)
  }
  
  func create(todo: TodoItem) async throws{
	 guard let id else { return }
	 
	 let endpoint = TodoEndpoint.create(uid: id, item: todo)
	 
	 try await FirestoreService.request(endpoint)
	 
	 todos.insert(todo, at: 0)
  }
  
  
  func update(todo: TodoItem){
	 guard let id else { return }
	 let endpoint = TodoEndpoint.update(uid: id, item: todo)
	 Task{
		do{
		  try await FirestoreService.request(endpoint)
		  
		  todos.removeAll(where: {$0.id == todo.id})
		  todos.append(todo)
		}catch{
		  
		}
	 }
  }
  
  func delete(todo: TodoItem){
	 guard let id else { return }
	 let endpoint = TodoEndpoint.delete(uid: id, id: todo.id)
	 
	 Task{
		do{
		  try await FirestoreService.request(endpoint)
		}catch{
		  
		}
	 }
  }
}
