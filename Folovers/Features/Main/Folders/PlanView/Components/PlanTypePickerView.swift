//
//  PlanTypePickerView.swift
//  Folovers
//
//  Created by user on 15.08.2026.
//

import SwiftUI

struct PlanTypePickerView: View {
  @Environment(\.theme) var theme
  @State private var planState: PlanType = .plans
    var body: some View {
		HStack{
		  ForEach(PlanType.allCases){item in
			 let active = item == planState
			 Button{
				withAnimation{
				  planState = item
				}
			 }label:{
				Text(item.title)
				  .font(active ? .largeTitle.weight(.black) : .headline)
				  .frame(maxWidth: .infinity, alignment: item.alignment)
				  .foregroundStyle(theme.primary)
				  .opacity(active ? 1 : 0.5)
			 }
		  }
		}
		.fontDesign(.monospaced)
		.padding()
		.compositingGroup()
    }
}

#Preview {
    PlanTypePickerView()
	 .environment(\.theme, .basic)
}


enum PlanType: String, Identifiable ,CaseIterable{
  case plans, memories
  
  var id: String{
	 self.rawValue
  }
  
  var title: String{
	 self.rawValue.capitalized
  }
  
  var alignment: Alignment{
	 switch self {
	 case .plans:
		  .leading
	 case .memories:
		  .trailing
	 }
  }
}
