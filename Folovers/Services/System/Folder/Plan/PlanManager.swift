//
//  PlanManager.swift
//  Folovers
//
//  Created by user on 16.08.2026.
//

import Foundation

@MainActor
final class PlanManager{
  
  
  func fetchPlans(folderId: String) async throws -> [PlanCard]{
	 let endPoint = PlanEndpoint(action: .fetchAll(folderId: folderId))
	 
	 return try await FirestoreService.request(endPoint)
  }
  
  func fetchPlan(folderId: String, planId: String) async throws -> PlanCard{
	 let endPoint = PlanEndpoint(action: .fetchOne(folderId: folderId, planId: planId))
	 
	 return try await FirestoreService.request(endPoint)
  }
  
  func createPlan(_ plan: PlanCard) async throws{
	 let endPoint = PlanEndpoint(action: .create(plan))
	 
	 try await FirestoreService.request(endPoint)
  }
  
  func updatePlan(_ plan: PlanCard) async throws{
	 let endPoint = PlanEndpoint(action: .update(plan))
	 
	 try await FirestoreService.request(endPoint)
  }
  
  func deletePlan(_ plan: PlanCard) async throws{
	 let endPoint = PlanEndpoint(action: .delete(plan))
	 
	 try await FirestoreService.request(endPoint)
  }
  
  
 
}
