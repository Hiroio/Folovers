//
//  CalendarSheetView.swift
//  Folovers
//
//  Created by user on 31.08.2026.
//

import SwiftUI

struct CalendarSheetView: View {
  @Environment(\.dismiss) var dismiss
  @Environment(\.theme) var theme
  @State var selectedMonth: Date = .now
    var body: some View {
		ZStack{
		  theme.background.ignoresSafeArea()
		  VStack{
			 Header
			 CalendarView(month: $selectedMonth)
			 Slider
			 
			 Spacer()
		  }
		  .padding()
		}
		.fontDesign(.monospaced)
    }
}

#Preview {
    CalendarSheetView()
	 .environment(\.theme, .basic)
}


extension CalendarSheetView{
  private var Header: some View{
	 HStack{
		Button{
		  
		}label:{
		  Image(systemName: "chevron.left")
			 .font(.title3)
		}
		
		Spacer()
		
		Text("Calendar")
		  .font(.title2)
		
		Spacer()
	 }
	 .foregroundStyle(theme.text)
  }
  
  private var Slider: some View{
	 HStack{
		Button{
		  withAnimation{
			 selectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth)!
		  }
		}label:{
		  Image(systemName: "chevron.left")
		}
		Text(selectedMonth.formatted(.dateTime.month(.wide)))
		  .frame(maxWidth: .infinity)
		
		Button{
		  withAnimation{
			 selectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth)!
		  }
		}label:{
		  Image(systemName: "chevron.right")
		}
	 }
	 .foregroundStyle(theme.text)
  }
}
