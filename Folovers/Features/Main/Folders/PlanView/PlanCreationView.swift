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
    var body: some View {
		VStack{
		  PlanTypePickerView()
		  ScrollView(){
			 VStack{
				TextField("", text: $planName, prompt:
								Text("Plan Name...")
				  .foregroundStyle(theme.primary)
				)
				.textFieldModifier()
				
				
				NoteTextEditor()
				  .aspectRatio(contentMode: .fit)
				
				PhotoSelection()
				
				LocationSelectionView()
				
				CustomDatePicker()
			 }
			 .fontDesign(.monospaced)
			 .card(10)
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
