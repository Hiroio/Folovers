//
//  CustomDatePicker.swift
//  Folovers
//
//  Created by user on 15.08.2026.
//

import SwiftUI

struct CustomDatePicker: View {
  @Binding var selectedDate: Date?
  @Environment(\.theme) var theme
  var body: some View {
		HStack{
		  Text("Date")
			 .frame(maxWidth: .infinity, alignment: .leading)
			 .font(.headline.weight(.bold))
			 .foregroundStyle(theme.primaryDark)
		  HStack{
			 DatePicker("", selection: date,
							in: Date.distantPast...,
							displayedComponents: .date,
			 )
			 .accentColor(theme.primary)
			 Image(systemName: "chevron.left")
		  }
		  .accentColor(theme.primary)
		  .foregroundStyle(theme.primary)
		}
		.border(10)
    }
  
  var date: Binding<Date>{
	 Binding {
		if let selectedDate{
		  return selectedDate
		}else{
		  return Date.now
		}
	 } set: { newValue in
		selectedDate = newValue
	 }

  }
}

#Preview {
  CustomDatePicker(selectedDate: .constant(.now))
	 .environment(\.theme, .basic)
	 .foregroundStyle(.redPrimaryDark)
}
