//
//  PlansListView.swift
//  Folovers
//
//  Created by user on 24.08.2026.
//

import SwiftUI

struct PlansListView: View {
  @Environment(\.theme) var theme
  let plans: [PlanCard]
  let state: PlanType
    var body: some View {
		ScrollView(){
		  let isPlan = state == .plans
		  LazyVStack(spacing: 10){
			 ForEach(plans){item in
				Button{
				  NavigationManager.shared.plan = item
				}label:{
				  HStack{
					 if !isPlan{
						Image(systemName: "chevron.left")
					 }
					 Text(item.title)
						.font(.title3.weight(.medium))
						.frame(maxWidth: .infinity, alignment: state.alignment)
						.lineLimit(2)
					 
					 if isPlan{
						Image(systemName: "chevron.right")
					 }
				  }
				  .foregroundStyle(theme.primaryDark)
				  .card(20)
				  .padding(1)
				}
				
			 }
		  }
		  .padding(isPlan ? .trailing : .leading, 25)
		}
		.defaultScrollAnchor(.bottom)
		.fontDesign(.monospaced)
    }
}

#Preview {
  PlansListView(plans: PlanCard.plans(), state: .memories)
	 .environment(\.theme, .basic)
}
