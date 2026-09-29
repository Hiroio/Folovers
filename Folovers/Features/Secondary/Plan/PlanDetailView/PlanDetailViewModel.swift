//
//  PlanDetailViewModel.swift
//  Folovers
//
//  Created by user on 25.08.2026.
//

import Foundation

@Observable
final class PlanDetailViewModel{
//  PlanDetailView holds off assigning the real plan for a reveal animation,
//  so this only fires once actual data (and a real createdBy) lands
  var plan: PlanCard{
	 didSet{
		guard plan.createdBy != oldValue.createdBy else { return }
		getCreator()
	 }
  }
  var isEditing: Bool = false
  var locationExtended: Bool = false
  var creator: UserDocument? = nil

  init(plan: PlanCard){
	 self.plan = .init(folderId: "", createdBy: "")
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
//  Refetched per plan on purpose - a shared folder's plans can each have a
//  different creator. ConnectionManager.user(for:) is cache first, so a
//  creator already known (a connection, or seen on another plan) costs
//  nothing beyond this dictionary lookup
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
