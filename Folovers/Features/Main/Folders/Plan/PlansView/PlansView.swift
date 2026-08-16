//
//  PlansView.swift
//  Folovers
//
//  Created by user on 16.08.2026.
//

import SwiftUI

struct PlansView: View {
  @State private var vm: PlansViewModel
  
  init(folderId: String){
	 self._vm = State(wrappedValue: PlansViewModel(folderId: folderId))
  }
  
    var body: some View {
		VStack{
		  Text("Folder")
		  
		  PlanTypePickerView(planState: $vm.plansState)
		  
		  
		  switch vm.plansState {
		  case .plans:
			 PlansSliderView(plans: PlanCard.plans(), state: .plans)
				.transition(PlanType.plans.transition)
		  case .memories:
			 PlansSliderView(plans: PlanCard.plans(), state: .memories)
				.transition(PlanType.memories.transition)
		  }
		}
    }
}

#Preview {
  PlansView(folderId: "")
}
