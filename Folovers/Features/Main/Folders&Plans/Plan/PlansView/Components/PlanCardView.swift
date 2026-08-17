//
//  PlanCardView.swift
//  Folovers
//
//  Created by user on 16.08.2026.
//

import SwiftUI

struct PlanCardView: View {
  @Environment(\.theme) var theme
  let plan: PlanCard
    var body: some View {
		VStack{
		  HStack(spacing: 10){
			 Text(plan.title)
				.frame(maxWidth: .infinity, alignment: .leading)
				.font(.title3.weight(.semibold))
				.lineLimit(2)
				.foregroundStyle(theme.primaryDark)
			 
			 VStack(alignment: .trailing){
				if let date = plan.date{
				  Text(date.formatted(.dateTime.year().month().day()))
					 .font(.footnote)
				}
				Text(plan.createdAt.formatted(.dateTime.month(.abbreviated).day()))
				  .font(.caption)
			 }
			 .foregroundStyle(theme.primary)
		  }
		  .padding(.vertical)
		  
		  HStack(spacing: 10){
			 PlanBlankCard(image: "note.text")
				.frame(maxWidth: .infinity)
			 VStack(spacing: 10){
				PlanBlankCard(image: "photo")
				PlanBlankCard(image: "map")
			 }
			 .frame(maxWidth: .infinity)
		  }
		  .foregroundStyle(theme.primary)
		  .aspectRatio(1.3, contentMode: .fit)
		}
		.card(15)
		.fontDesign(.monospaced)
    }
}

#Preview {
  PlanCardView(plan: .init(id: "", folderId: "", title: "Some sort of plan", date: .distantFuture, photos: [], isCompleted: false, createdBy: "", createdAt: .now))
	 .environment(\.theme, .basic)
}


extension PlanCardView{
  func PlanBlankCard(image: String) -> some View{
	 Image(systemName: image)
		.font(.title)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.border()
  }
}
