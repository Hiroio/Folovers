//
//  TodoModel.swift
//  Folovers
//
//  Created by user on 01.09.2026.
//

import Foundation


enum TodoPrivacy: String, Codable, CaseIterable {
  case `private`, `public`
  
  
  var icon: String{
	 switch self {
	 case .private:
		"lock.fill"
	 case .public:
		"lock.open.fill"
	 }
  }
}

struct TodoItem: FirestoreIdentifiable {
  var id: String
  var title: String
  var note: String?
  var date: Date?
  var privacy: TodoPrivacy
  var isDone: Bool
  var colortheme: AppThemeColor
  var createdAt: Date
}

extension TodoItem{
  static func preview(id: String) -> TodoItem{
	 return .init(
		id: id,
		title: "Some Item to do #\(id)",
		note: "you need to do certain things",
//		date: .now,
		privacy: id == "6" ? .private : .public,
		isDone: false,
		colortheme: .green,
		createdAt: .now
	 )
  }
}



extension Array where Element == TodoItem{
  static var todoItems: [TodoItem]{
	 return (0...15).map({TodoItem.preview(id: "\($0)")})
  }
}
