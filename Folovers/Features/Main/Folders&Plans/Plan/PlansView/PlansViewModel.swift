//
//  PlanViewModel.swift
//  Folovers
//
//  Created by user on 16.08.2026.
//

import Foundation

@MainActor
@Observable
final class PlansViewModel{
  var plans: [PlanCard] = []
  let folderId: String
  var plansState: PlanType = .plans
  var creationState: Bool = false
  var planGridState: Bool = false
  var memoriesGridState: Bool = false
  
  init(folderId: String){
	 self.folderId = folderId
  }
  
  
  
  private let planManager = PlanManager()
  private let storageManager = StorageManager.shared
  
  
  var plansItems: [PlanCard]{
	 plans.filter({!$0.isCompleted})
  }
  var memoriesItems: [PlanCard]{
	 PlanCard.plans()
  }
}

extension PlansViewModel{
  
  
  func fetchAllPlans(){
	 Task{
		do{
		  let fetchedPlans = try await planManager.fetchPlans(folderId: folderId)
		  self.plans = fetchedPlans
		  self.filterPlansForUnUploaded(plans: fetchedPlans)
		}catch{
		  print("DEBUG: Failed To Fetch plans")
		}
	 }
  }
  
  func filterPlansForUnUploaded(plans: [PlanCard]){
	 let filtered = plans.filter({$0.photos.contains(where: {$0.status == .failed})})
	 
	 if !filtered.isEmpty{
		storageManager.startReloadingTask(plans: filtered)
	 }
  }
}
