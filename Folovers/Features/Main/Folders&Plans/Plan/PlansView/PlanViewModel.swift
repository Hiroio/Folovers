//
//  PlanViewModel#2.swift
//  Folovers
//
//  Created by user on 29.08.2026.
//

import Foundation

@MainActor
@Observable
final class PlansViewModel{
  var plans: [PlanCard] = []
  let folder: FolderModel
  var plansState: PlanType = .plans
  var creationState: Bool = false
  var creationType: PlanType = .plans
  var gridView: PlanGridViewEnum = .three
  var memoriesGridState: Bool = false
  var showMenu: Bool = false
  var editingState: Bool = false
  
  init(folder: FolderModel){
	 self.folder = folder
  }
  
  
  
  
  private let planManager = PlanManager()
  private let storageManager = StorageManager.shared
  
  
  var plansItems: [PlanCard]{
	 plans.filter({!$0.isCompleted})
  }
  
  var memoriesItems: [PlanCard]{
	 plans.filter({ $0.isCompleted })
  }
  var folderId: String {
	 self.folder.id
  }
}

extension PlansViewModel{
  func startCreation(type: PlanType){
	 creationType = type
	 creationState = true
  }

  
  
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



enum PlanGridViewEnum: Int,Identifiable, CaseIterable{
  case three = 3
  case two = 2
  
  
  var id: Int{
	 self.rawValue
  }
  
  var ratio: CGFloat{
	 switch self {
	 case .three:
		1/2
	 case .two:
		1/1.5
	 }
  }
  
  
  var icon: String{
	 switch self {
	 case .three:
		"rectangle.grid.3x2"
	 case .two:
		"rectangle.grid.2x2"
	 }
  }
}
