//
//  PlanGridView.swift
//  Folovers
//
//  Created by user on 24.08.2026.
//

import SwiftUI

struct PlanGridView: View {
  @Environment(\.theme) var theme
  @Bindable var vm: PlansViewModel
    var body: some View {
		ZStack{
		  switch vm.plansState {
		  case .plans:
			 VStack{
				gridStateView(total: vm.plansItems.count, type: .plans, state: vm.planGridState)
				
				ZStack{
				  if vm.planGridState{
					 PlansListView(plans: vm.plansItems, state: .plans)
				  }else{
					 PlansSliderView(plans: vm.plansItems, state: .plans, onCreate: { vm.startCreation(type: .plans) })
				  }
				}
				.frame(maxHeight: .infinity, alignment: .bottom)
			 }
			 .transition(PlanType.plans.transition)
		  case .memories:
			 VStack{
				gridStateView(total: vm.memoriesItems.count, type: .memories, state: vm.memoriesGridState)
				
				ZStack{
				  if vm.memoriesGridState{
					 PlansListView(plans: vm.memoriesItems, state: .memories)
						.transition(.move(edge: .top).combined(with: .opacity).combined(with: .scale))
				  }else{
					 PlansSliderView(plans: vm.memoriesItems, state: .memories, onCreate: { vm.startCreation(type: .memories) })
						.transition(.move(edge: .top).combined(with: .opacity).combined(with: .scale))
				  }
				}
				.frame(maxHeight: .infinity, alignment: .bottom)
			 }
			 .transition(PlanType.memories.transition)
		  }
		}
		.frame(maxHeight: .infinity, alignment: .bottom)
    }
}

#Preview {
  PlanGridView(vm: PlansViewModel(folderId: ""))
	 .environment(\.theme, .basic)
}

extension PlanGridView{
  @ViewBuilder
  func gridStateView(total: Int, type: PlanType, state: Bool) -> some View{
	 HStack{
		Text("Total \(type.title): \(total)")
		  .foregroundStyle(theme.primaryDark)
		  .frame(maxWidth: .infinity, alignment: .leading)
		
		if state{
		  Button{
			 withAnimation{
				switchState(type: type)
			 }
		  }label: {
			 Text("Show Slider")
		  }
		}else{
		  Button{
			 withAnimation{
				switchState(type: type)
			 }
		  }label: {
			 Text("Show List")
		  }
		}
	 }
	 .foregroundStyle(theme.primary)
	 .fontDesign(.monospaced)
	 .padding(.horizontal)
  }
  
  
  func switchState(type: PlanType){
	 switch type {
	 case .plans:
		vm.planGridState.toggle()
	 case .memories:
		vm.memoriesGridState.toggle()
	 }
  }
}
