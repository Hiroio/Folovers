//
//  PlanCreationViewModel.swift
//  Folovers
//
//  Created by user on 16.08.2026.
//

import Foundation
import SwiftUI

@Observable
final class PlanCreationViewModel{
  var plan: PlanCard
  let folderId: String
  let isEditing: Bool
  var planState: PlanType = .plans

  private let originalPlan: PlanCard
  private var planBinding: Binding<PlanCard>?

  private let planManager = PlanManager()

  init(folderId: String = "", plan: Binding<PlanCard>? = nil){
	 if let plan{
		self.plan = plan.wrappedValue
		self.folderId = plan.wrappedValue.folderId
		self.isEditing = true
		self.originalPlan = plan.wrappedValue
		self.planBinding = plan
	 }else{
		let newPlan: PlanCard
		if let uid = AuthManager.shared.id{
		  newPlan = PlanCard(folderId: folderId, createdBy: uid)
		}else{
		  newPlan = PlanCard(folderId: folderId, createdBy: "")
		}
		self.plan = newPlan
		self.folderId = folderId
		self.isEditing = false
		self.originalPlan = newPlan
		self.planBinding = nil
	 }
  }


  var actionBtnName: String{
	 isEditing ? "Edit" : "Create"
  }

  var headerText: String{
	 let name = planState == .plans ? "Plan" : "Memorie"
	 return (isEditing ? "Edit " : "Create ") + name
  }


}



extension PlanCreationViewModel{
  func submitAction(){
	 if isEditing {
		updatePlan()
	 }else{
		createPlan()
	 }
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
  
  func updatePlan(){
	 Task{
		do{
		  try await planManager.updatePlan(plan)
		}catch{
		  print("DEBUG: Failed to edit Plan")
		}
	 }
  }
}
