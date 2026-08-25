//
//  PlanCreationView.swift
//  Folovers
//
//  Created by user on 15.08.2026.
//

import SwiftUI

struct PlanCreationView: View {
  @Environment(\.dismiss) var dismiss
  @Environment(\.theme) var theme
  @State private var scrollPosition: String? = "NameSection"
  let onSubmit: () -> ()
  init(folderId: String, planState: PlanType = .plans, onCreate: @escaping() -> ()){
	 self._vm = State(wrappedValue: PlanCreationViewModel(folderId: folderId, planState: planState))
	 self.onSubmit = onCreate
  }
  
  
  @State private var vm: PlanCreationViewModel
  var body: some View {
	 ZStack{
		VStack{
		  PlanHeader(title: vm.headerText, creation: !vm.isEditing, ableToCreate: !vm.plan.title.isEmpty){
			 vm.submitAction()
			 onSubmit()
			 dismiss()
		  }
		  .padding()
		  
		  VStack{
			 if scrollPosition == "NameSection"{
				PlanTypePickerView(planState: $vm.planState)
				  .transition(.opacity.combined(with: .scale).combined(with: .move(edge: .top)))
			 }else{
				Text(vm.planState.title)
				  .transition(.opacity)
				  .font(.footnote.weight(.bold))
				  .foregroundStyle(theme.primary)
			 }
		  }
		  
		  ScrollViewReader{ proxy in
			 ScrollView(showsIndicators: false){
				VStack(spacing: 15){
				  VStack(alignment: .leading, spacing: 5){
					 Text("Name")
						.font(.headline.weight(.bold))
						.foregroundStyle(theme.primaryDark)
					 
					 TextField("", text: $vm.plan.title, prompt:
									 Text("Plan Name...")
						.foregroundStyle(theme.primary)
					 )
					 .textFieldModifier()
				  }
				  .id("NameSection")
				  .padding(.vertical)
				  
				  
				  NoteTextEditor(noteText: $vm.plan.note)
					 .frame(maxWidth: .infinity)
					 .aspectRatio(1, contentMode: .fit)
					 .id("NoteSection")
				  
				  PhotoSelection(photos: $vm.selectedPhotos, photoAttachments: $vm.plan.photos)
					 .id("PhotoSelection")
				  
				  LocationSelectionView(planLocation: vm.plan.location){vm.locationSheet.toggle()}
					 .id("LocationSelection")
				  
				  CustomDatePicker(selectedDate: $vm.plan.date)
					 .id("DateSection")
				}
				.card(15)
				.padding(1)
				.padding(.bottom)
				.scrollTargetLayout()
			 }
			 .scrollDismissesKeyboard(.immediately)
			 .scrollPosition(id: $scrollPosition)
			 .padding()
		  }
		}
		.fontDesign(.monospaced)
		.sheet(isPresented: $vm.locationSheet) {
		  LocationSelectionSheet(){ location in
			 vm.plan.location = location
		  }
		  .presentationDetents([.medium, .large])
		}
		.animation(.easeInOut, value: scrollPosition)
		
		if let photoPreview = NavigationManager.shared.popUps.last{
		  ZStack{
			 Color.black.opacity(0.3).ignoresSafeArea()
				.onTapGesture {
				  NavigationManager.shared.popPopUp()
				}
			 switch photoPreview {
			 case .photo(let photoKF, let photoUI):
				PhotoPreviewView(photo: photoUI, photoURL: photoKF)
				  .transition(.move(edge: .bottom))
			 default:
				EmptyView()
			 }
		  }
		}
	 }
	 .animation(.easeInOut, value: NavigationManager.shared.popUps.count)
  }
}


extension PlanCreationView{
  init(plan: Binding<PlanCard>){
	 self._vm = State(wrappedValue: PlanCreationViewModel(plan: plan))
	 self.onSubmit = {}
  }
}

#Preview {
  ZStack{
	 ThemePalette.basic.background.ignoresSafeArea()
	 PlanCreationView(folderId: ""){}
		.environment(\.theme, .basic)
  }
}
