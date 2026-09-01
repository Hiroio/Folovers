//
//  PlanDetailViewModel.swift
//  Folovers
//
//  Created by user on 25.08.2026.
//

import Foundation

@Observable
final class PlanDetailViewModel{
  var plan: PlanCard
  var isEditing: Bool = false
  var locationExtended: Bool = false
  var creator: UserDocument? = nil

  init(plan: PlanCard){
	 self.plan = .init(folderId: "", createdBy: "")
	 getCreator()
  }

  var locationIsAble: Bool {
	 plan.location != nil
  }

  var dateText: String? {
	 guard let date = plan.date else { return nil }
	 return date.formatted(.dateTime.day(.defaultDigits).month(.abbreviated).year())
  }
}

extension PlanDetailViewModel{
  func getCreator(){
//	 An empty uid would hit Firestore's document("") and raise, not throw
	 guard !plan.createdBy.isEmpty else { return }

	 Task{
		creator = await ConnectionManager.user(for: plan.createdBy)
	 }
  }

  func startEditing(){
	 isEditing = true
  }

  func toggleLocation(){
	 locationExtended.toggle()
  }

  func close(){
	 NavigationManager.shared.plan = nil
  }
}
