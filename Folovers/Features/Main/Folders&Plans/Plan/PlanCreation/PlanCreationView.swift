//
//  PlanCreationView.swift
//  Folovers
//
//  Created by user on 15.08.2026.
//

import SwiftUI

struct PlanCreationView: View {
  @Environment(\.theme) var theme
  @State private var planName: String = ""
  @State private var vm = PlanCreationViewModel(folderId: "")
    var body: some View {
		VStack{
		  PlanHeader(title: planName.isEmpty ? "New Plan" : planName, creation: true, ableToCreate: !planName.isEmpty)
			 .padding(.horizontal)
		  PlanTypePickerView(planState: $vm.planState)
		  ScrollView(){
			 VStack(spacing: 15){
				VStack(alignment: .leading, spacing: 5){
				  Text("Name")
					 .font(.headline.weight(.bold))
					 .foregroundStyle(theme.primaryDark)
					 
				  TextField("", text: $planName, prompt:
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
				
				LocationSelectionView()
				
				CustomDatePicker(selectedDate: $vm.plan.date)
			 }
			 .fontDesign(.monospaced)
			 .card(15)
			 .padding(1)
		  }
		  .padding()
		}
    }
}

#Preview {
  ZStack{
	 ThemePalette.basic.background.ignoresSafeArea()
	 PlanCreationView()
		.environment(\.theme, .basic)
  }
}
