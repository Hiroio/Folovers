//
//  CalendarView.swift
//  Folovers
//
//  Created by user on 31.08.2026.
//

import SwiftUI

struct CalendarView: View {
  @Environment(\.theme) var theme
  @Binding var month: Date
  @State private var days: [Date] = []
  @State private var drag: CGSize = .zero
  let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    var body: some View {
		VStack(spacing: 10){
		  VStack{
			 HStack{
				ForEach(daysOfWeek, id: \.self){item in
				  Text(item)
					 .frame(maxWidth: .infinity)
				}
			 }
			 .frame(maxWidth: .infinity)
			 .padding(.vertical)
			 .card(lineWidth: 3)
			 LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
				ForEach(updateDays(), id: \.self){day in
				  Text(day.formatted(.dateTime.day(.twoDigits)))
					 .foregroundStyle(day.inCurrentMonth ? theme.text : theme.secondaryText)
					 .padding(3)
					 .background(
						Circle()
						  .fill(day.isToday ? theme.surface : .clear)
					 )
				}
			 }
		  }
		  .padding(.bottom)
		  .border()
		  .background(
			 RoundedRectangle(cornerRadius: 15)
				.fill(theme.background)
		  )
		  .offset(x: drag.width)
		  .gesture(
			 DragGesture()
				.onChanged({ translation in
				  print(translation.translation)
				  drag = translation.translation
				})
				.onEnded({ _ in
				  withAnimation{
					 if drag.width > 50{
						month = Calendar.current.date(byAdding: .month, value: 1, to: month)!
				  }else if drag.width < 50{
						month = Calendar.current.date(byAdding: .month, value: -1, to: month)!
				  }
				  drag = .zero
				}
				})
		  )
		  
		}
		.fontDesign(.monospaced)
    }
  
  
  private func updateDays() -> [Date] {
	 month.calendarDisplayDays
	}
}

#Preview {
  CalendarView(month: .constant(.now))
}


extension CalendarView{
  
  
  func dragGesture() -> some Gesture{
		DragGesture()
		  .onChanged { translation in
			 print(translation.translation)
			 let distance = translation.translation
			 drag = distance
			 
		  }
		  .onEnded { translation in
			 print(drag)
			 if drag.width > 50{
				print("next")
			 }else if drag.width < 50{
				print("back")
			 }
		  }
	 }
}
