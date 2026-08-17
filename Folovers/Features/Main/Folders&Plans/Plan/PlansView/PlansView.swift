//
//  PlansView.swift
//  Folovers
//
//  Created by user on 16.08.2026.
//

import SwiftUI

struct PlansView: View {
  @Environment(\.theme) var theme
  @State private var vm: PlansViewModel
  init(folderId: String){
	 self._vm = State(wrappedValue: PlansViewModel(folderId: folderId))
  }
  
    var body: some View {
		VStack{
		  PlansViewHeader
		  
		  PlanTypePickerView(planState: $vm.plansState)
		  
		  ZStack{
			 switch vm.plansState {
			 case .plans:
				PlansSliderView(plans: vm.plans, state: .plans)
				  .transition(PlanType.plans.transition)
			 case .memories:
				PlansSliderView(plans: PlanCard.plans(), state: .memories)
				  .transition(PlanType.memories.transition)
			 }
		  }
		  .frame(maxHeight: .infinity, alignment: .bottom)
		  }
		.contentShape(.rect)
		.simultaneousGesture(
		  DragGesture(minimumDistance: 20)
			 .onChanged { value in
				let horizontal = value.translation.width
				guard abs(horizontal) > 50 else { return }
				
				let target: PlanType = horizontal < 0 ? .memories : .plans
				if vm.plansState != target {
				  withAnimation {
					 vm.plansState = target
				  }
				}
			 }
		)
    }
}

#Preview {
  PlansView(folderId: "")
	 .environment(\.theme, .basic)
}


extension PlansView{
  private var PlansViewHeader: some View{
	 HStack(spacing: 15){
		Button{
		  withAnimation {
			 NavigationManager.shared.popSecondary()
		  }
		}label:{
		  Image(systemName: "chevron.left")
			 .font(.title2)
			 .foregroundStyle(theme.primaryDark)
		}
		VStack(alignment: .leading){
		  Text("Plans")
			 .font(.title2)
			 .foregroundStyle(theme.text)
		  Text("Your plans & memories")
			 .font(.caption)
			 .foregroundStyle(theme.secondaryText)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		
		Image(systemName: "plus")
		  .font(.title2)
		  .foregroundStyle(theme.primaryDark)
	 }
	 .padding(.horizontal)
	 .fontDesign(.monospaced)
  }
}
