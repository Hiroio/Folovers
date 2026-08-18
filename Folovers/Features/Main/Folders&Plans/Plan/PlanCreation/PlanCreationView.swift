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
  let onSubmit: () -> ()
  init(folderId: String, onCreate: @escaping() -> ()){
	 self._vm = State(wrappedValue: PlanCreationViewModel(folderId: folderId))
	 self.onSubmit = onCreate
  }

  
  @State private var vm: PlanCreationViewModel
    var body: some View {
		VStack{
		  PlanHeader(title: vm.headerText, creation: !vm.isEditing, ableToCreate: vm.plan.title.isEmpty){
			 vm.submitAction()
			 onSubmit()
			 dismiss()
		  }
			 .padding(.horizontal)
		  
		  
		  PlanTypePickerView(planState: $vm.planState)
		  
		  ScrollViewReader{ proxy in
			 ScrollView(){
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
				  .padding(.vertical)
				  
				  
				  NoteTextEditor()
					 .frame(maxWidth: .infinity)
					 .aspectRatio(1, contentMode: .fit)
				  
				  PhotoSelection(photoAttachments: vm.plan.photos)
					 .id("PhotoSelection")
				  
				  LocationSelectionView()
					 .id("LocationSelection")
				  
				  CustomDatePicker(selectedDate: $vm.plan.date)
				}
				.fontDesign(.monospaced)
				.card(15)
				.padding(1)
				.padding(.bottom)
			 }
			 .padding()
			 .onAppear{
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
				  proxy.scrollTo("PhotoSelection")
				}
			 }
		  }
		  
		  
		}
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
