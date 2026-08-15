//
//  CustomDatePicker.swift
//  Folovers
//
//  Created by user on 15.08.2026.
//

import SwiftUI

struct CustomDatePicker: View {
  @State private var selectedDate: Date = .now
  @Environment(\.theme) var theme
  var body: some View {
		HStack{
		  Text("Date")
			 .frame(maxWidth: .infinity, alignment: .leading)
			 .font(.headline.weight(.bold))
		  
		  HStack{
			 DatePicker("", selection: $selectedDate,
							in: ...Date(),
							displayedComponents: .date,
			 )
			 Image(systemName: "chevron.left")
		  }
		}
		.border(5)
    }
}

#Preview {
    CustomDatePicker()
	 .environment(\.theme, .basic)
	 .foregroundStyle(.redPrimaryDark)
}
