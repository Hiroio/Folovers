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
  var selectedPhotos: [UIImage] = []
  var locationSheet: Bool = false
  var planState: PlanType = .plans {
	 didSet{
		if self.planState == .plans {
		  self.plan.isCompleted = false
		}else{
		  self.plan.isCompleted = true
		}
	 }
  }

  private let originalPlan: PlanCard
  private var planBinding: Binding<PlanCard>?

  private let planManager = PlanManager()
  private let storageManager = StorageManager.shared

  init(folderId: String = "", plan: Binding<PlanCard>? = nil, planState: PlanType = .plans){
	 if let plan{
		self.plan = plan.wrappedValue
		self.folderId = plan.wrappedValue.folderId
		self.isEditing = true
		self.originalPlan = plan.wrappedValue
		self.planBinding = plan
//		While editing the type comes from the plan itself, not from the caller
		self.planState = plan.wrappedValue.isCompleted ? .memories : .plans
	 }else{
		var newPlan: PlanCard
		if let uid = AuthManager.shared.id{
		  newPlan = PlanCard(folderId: folderId, createdBy: uid)
		}else{
		  newPlan = PlanCard(folderId: folderId, createdBy: "")
		}
//		didSet does not fire inside init, so isCompleted is set by hand
		newPlan.isCompleted = planState == .memories

		self.plan = newPlan
		self.folderId = folderId
		self.isEditing = false
		self.originalPlan = newPlan
		self.planBinding = nil
		self.planState = planState
	 }
  }


  var actionBtnName: String{
	 isEditing ? "Edit" : "Create"
  }
  
  var ableToCreate: Bool{
	 if isEditing{
		originalPlan.photos != plan.photos || !selectedPhotos.isEmpty || originalPlan.title != plan.title || originalPlan.note != plan.note || originalPlan.location != plan.location || originalPlan.date != plan.date || originalPlan.isCompleted != plan.isCompleted
	 }else{
		!plan.title.isEmpty
	 }
  }

  var headerText: String{
	 let name = planState == .plans ? "Plan" : "Memorie"
	 return (isEditing ? "Edit " : "Create ") + name
  }


}


// MARK: ---------- -=| Creating || Editing |=- ---------------------
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
		  let photoAttachments = await uploadPhoto()
		  var planToUpload = plan
		  planToUpload.photos = photoAttachments
		  planToUpload.createdAt = .now
		  try await planManager.createPlan(planToUpload)
		}catch{
		  print("DEBUG: Failed to create Plan")
		}
	 }
  }
  
  func updatePlan(){
	 Task{
		do{
		  var planToUpload = plan

		  if originalPlan.photos != plan.photos || !selectedPhotos.isEmpty{
			 planToUpload.photos = await storageManager.reconcilePhotos(
				original: originalPlan.photos,
				current: plan.photos,
				newImages: selectedPhotos,
				folderId: plan.folderId
			 )
		  }

		  try await planManager.updatePlan(planToUpload)

		  plan = planToUpload
		  planBinding?.wrappedValue = planToUpload
		  selectedPhotos = []
		}catch{
		  print("DEBUG: Failed to edit Plan")
		}
	 }
  }
  
  
}

// MARK: ---------- -=| UTILITY |=- --------------
extension PlanCreationViewModel{
  func uploadPhoto() async -> [PhotoAttachment]{
	 guard !selectedPhotos.isEmpty else { return [] }

	 let attachments = storageManager.createAttachments(from: selectedPhotos)
	 return await storageManager.uploadPhotos(attachments, folderId: plan.folderId)
  }
}
