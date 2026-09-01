//
//  PlanHeader.swift
//  Folovers
//
//  Created by user on 16.08.2026.
//

import SwiftUI

struct PlanHeader: View {
  @Environment(\.dismiss) var dismiss
  @Environment(\.theme) var theme
  let title: String
  let creation: Bool
  let ableToCreate: Bool
  let onSubmit: () -> ()
    var body: some View {
		HStack{
		  Text(title)
			 .font(.title3.weight(.bold))
			 .foregroundStyle(theme.primaryDark)
			 .padding(.horizontal, 80)
			 .multilineTextAlignment(.center)
			 .lineLimit(2)
		}
		.frame(maxWidth: .infinity)
		.overlay{
		  HStack(alignment: .top){
			 Button{
				dismiss()
			 }label: {
				Image(systemName: "chevron.left")
				  .font(.title3.weight(.bold))
			 }
			 Spacer()
			 
			 Button{
				withAnimation{
				  onSubmit()
				}
			 }label: {
				Text(actionText)
				  .font(.headline)
			 }
			 .disabled(!ableToCreate)
			 .opacity(ableToCreate ? 1 : 0.5)
		  }
		  .frame(maxHeight: .infinity, alignment: .center)
		}
		
		.foregroundStyle(theme.primary)
    }
  
  private var actionText: String{
	 creation ? "Create" : "Submit"
  }
}

#Preview {
  ZStack{
	 ThemePalette.basic.background.ignoresSafeArea()
	 PlanHeader(title: "New Plan to create or to enhance", creation: true, ableToCreate: true, onSubmit: {})
		.environment(\.theme, .basic)
		.fontDesign(.monospaced)
  }
}
