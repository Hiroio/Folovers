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
  
  
  init(folderId: String){
	 self.folderId = folderId
  }
  
  private let planManager = PlanManager()
  
  func fetchAllPlans(){
	 Task{
		do{
		  let fetchedPlans = try await planManager.fetchPlans(folderId: folderId)
		  self.plans = fetchedPlans
		}catch{
		  print("DEBUG: Failed To Fetch plans")
		}
	 }
  }
}
