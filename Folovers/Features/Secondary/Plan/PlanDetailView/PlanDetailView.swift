//
//  PlanDetailView.swift
//  Folovers
//
//  Created by user on 24.08.2026.
//

import SwiftUI
import SpritePackage

struct PlanDetailView: View {
  @Environment(\.theme) var theme
  @State private var vm: PlanDetailViewModel
  let plan: PlanCard
  
  init(plan: PlanCard){
	 self._vm = State(wrappedValue: PlanDetailViewModel(plan: plan))
	 self.plan = plan
  }
  
  var body: some View {
	 VStack{
		header
		  .padding(.bottom)
		
		ScrollView{
		  VStack(spacing: 15){
			 VStack(alignment: .leading, spacing: 10){
				Text("Plan Title")
				  .font(.subheadline.weight(.bold))
				
				Text(vm.plan.title)
				  .font(.title3.weight(.semibold))
			 }
			 .frame(maxWidth: .infinity, alignment: .leading)
			 .border(10)
			 
			 if let dateText = vm.dateText{
				VStack{
				  Text("Date")
					 .font(.headline)
				  
				  Text(dateText)
					 .card(10)
				}
				.border(10)
			 }
			 
			 
			 VStack{
				Button{
				  withAnimation{
					 vm.toggleLocation()
				  }
				}label:{
				  HStack{
					 Image(systemName: "drop.fill")
						.rotationEffect(Angle(degrees: 180))
					 Text("Location:")
						.font(.subheadline.weight(.bold))
					 Spacer()
					 Text(vm.plan.location?.name ?? "None")
						.lineLimit(1)
					 
					 if vm.locationIsAble{
						Image(systemName: "chevron.down")
						  .rotationEffect(Angle(degrees: vm.locationExtended ? -180 : 0))
					 }
					 
				  }
				  .padding(.vertical, 5)
				}
				.disabled(!vm.locationIsAble)
				if let location = vm.plan.location{
				  if vm.locationExtended{
					 MapFrameView(location: location)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.aspectRatio(2,contentMode: .fit)
						.clipShape(.rect(cornerRadius: 15))
						.border(1)
				  }
				}
			 }
			 .border(10, dashed: vm.plan.location == nil)
			 
			 PhotoSelection(photos: .constant([]), photoAttachments: .constant(vm.plan.photos), creation: false)
			 
			 NoteTextEditor(noteText: .constant(vm.plan.note))
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.disabled(true)
		  }
		  .padding(1)
		}
		.padding()
		createdBy
	 }
	 .task{
		try? await Task.sleep(for: .seconds(0.5))
		withAnimation(.bouncy){
		  self.vm.plan = plan
		}
		
		try? await Task.sleep(for: .seconds(0.1))
		withAnimation {
		  vm.locationExtended = true
		}
	 }
	 .foregroundStyle(theme.primaryDark)
	 .fontDesign(.monospaced)
	 .fullScreenCover(isPresented: $vm.isEditing){
		PlanCreationView(plan: $vm.plan)
	 }
  }
}

#Preview {
  ZStack{
	 ThemePalette.basic.background.ignoresSafeArea()
	 
	 PlanDetailView(plan: .plans().first!)
		.environment(\.theme, .basic)
  }
}

extension PlanDetailView{
  private var header: some View{
	 Text("Plan")
		.font(.title2.weight(.semibold))
		.frame(maxWidth: .infinity)
		.overlay(alignment: .leading) {
		  HStack{
			 Button{
				vm.close()
			 }label: {
				Image(systemName: "chevron.left")
				  .font(.title2)
			 }
			 Spacer()
			 
			 Button{
				vm.startEditing()
			 }label:{
				Text("Edit")
				  .font(.subheadline.weight(.semibold))
			 }
		  }
		}
		.padding()
  }
  
  private var createdBy: some View{
	 HStack{
		Text("CreatedBy:")
		  .font(.subheadline.weight(.bold))
		
		if let creator = vm.creator{
		  SpriteView(action: .preview, config: creator.characterConfig, size: CGSize(width: 30, height: 30))
		  
		  Text(creator.displayName)
			 .font(.subheadline)
		}else{
		  Text("...")
			 .font(.subheadline)
			 .foregroundStyle(theme.secondaryText)
		}
	 }
	 .border(15, lineWidth: 1)
  }
}
