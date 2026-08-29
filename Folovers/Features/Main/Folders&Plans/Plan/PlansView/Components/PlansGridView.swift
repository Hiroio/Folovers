//
//  PlansGridView.swift
//  Folovers
//
//  Created by user on 29.08.2026.
//

import SwiftUI

struct PlansGridView: View {
  @Bindable var vm: PlansViewModel
  let plans: [PlanCard]
    var body: some View {
		ScrollView{
		  LazyVGrid(columns: Array(repeating: .init(.flexible()), count: vm.gridView.rawValue)){
			 let color = vm.folder.folderColor.palette.primary
			 Button{
				withAnimation {
				  vm.startCreation(type: vm.plansState)
				}
			 }label:{
				Image(systemName: "plus.circle")
				  .font(.title)
				  .foregroundStyle(color)
				  .frame(maxWidth: .infinity, maxHeight: .infinity)
				  .aspectRatio(vm.gridView.ratio, contentMode: .fit)
				  .padding(10)
				  .border(color: color)
				  
			 }
			 
			 ForEach(plans){plan in
				  PlanGridCard(plan: plan)
			 }
			 
		  }
		  .padding(30)
		}
		.fontDesign(.monospaced)
    }
}

#Preview {
  ZStack{
	 ThemePalette.basic.background.ignoresSafeArea()
	 PlansGridView(vm: .init(folder: .personal), plans: PlanCard.plans())
  }
}

extension PlansGridView{
  @ViewBuilder
  func PlanGridCard(plan: PlanCard) -> some View{
	 VStack(alignment: .leading){
		Text(plan.title)
		  .fontWeight(.semibold)
		  .multilineTextAlignment(.leading)
		  .frame(maxHeight: .infinity, alignment: .top)
		
		if vm.gridView == .two{
		  VStack(alignment: .leading){
			 HStack{
				Image(systemName: "photo")
				Text(": \(plan.photos.filter({$0.status == .uploaded}).count)")
			 }
			 HStack(alignment: .top){
				Image(systemName: "drop.fill")
				  .rotationEffect(Angle(degrees: 180))
				Text(": \(plan.location?.name ?? "None")")
				  .lineLimit(1)
			 }
		  }
		  .foregroundStyle(plan.cardAccent.palette.primaryDark)
		}
		Text(plan.createdAt.formatted(.dateTime.day().month().year()))
		  .font(.footnote.weight(.medium))
	 }
	 .frame(maxWidth: .infinity, maxHeight: .infinity)
	 .aspectRatio(vm.gridView.ratio, contentMode: .fit)
	 .padding(10)
	 .background(
		RoundedRectangle(cornerRadius: 15)
		  .fill(plan.cardAccent.palette.surface)
	 )
  }
}
