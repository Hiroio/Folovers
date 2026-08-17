//
//  PlanCreationViewModel.swift
//  Folovers
//
//  Created by user on 16.08.2026.
//

import Foundation

@Observable
final class PlanCreationViewModel{
  var plan: PlanCard
  let folderId: String
  var planState: PlanType = .plans
  
  
  private let planManager = PlanManager()
  
  init(folderId: String){
	 if let uid = AuthManager.shared.id{
		let plan = PlanCard(folderId: folderId, createdBy: uid)
		self.plan = plan
	 }else{
		let plan = PlanCard(folderId: folderId, createdBy: "")
		self.plan = plan
	 }
	 self.folderId = folderId
  }
  
  
  func createPlan(){
	 Task{
		do{
		  try await planManager.createPlan(plan)
		}catch{
		  print("DEBUG: Failed to create Plan")
		}
	 }
  }
}
