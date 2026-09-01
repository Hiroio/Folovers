//
//  CalendarSheetView.swift
//  Folovers
//
//  Created by user on 31.08.2026.
//

import SwiftUI

struct CalendarSheetView: View {
  @Environment(\.theme) var theme
  @State private var vm = TodosViewModel()
  @State var selectedMonth: Date = .now
  @State var selectedDay: Date = .now
  @State private var isCollapsed: Bool = false
  @State private var isUserScrolling: Bool = false

  private let collapsibleHeight: CGFloat = 180
  private let collapseThreshold: CGFloat = 20
  var body: some View {
	 ZStack{
		theme.background.ignoresSafeArea()
		VStack{
		  Header
		  
		  CalendarView(month: $selectedMonth, selectedDay: $selectedDay ,isCollapsed: isCollapsed)
			 .padding(.vertical, 10)
		  
		  Slider
		  
		  ScrollView(showsIndicators: false){
			 LazyVStack{
				ForEach(vm.selectedDayTodos){item in
				  TodoItemView(todoItem: item, onComplete: {})
					 .id(item.id)
				}
			 }
			 .padding(1)
			 .scrollTargetLayout()
		  }
		  .onScrollPhaseChange{ _, phase in
			 isUserScrolling = phase != .idle
		  }
		  .onScrollGeometryChange(for: ScrollReading.self){ geometry in
			 ScrollReading(
				offset: geometry.contentOffset.y + geometry.contentInsets.top,
				overflow: geometry.contentSize.height - geometry.containerSize.height
			 )
		  } action: { _, reading in
			 guard isUserScrolling else { return }

			 let collapse = reading.offset > collapseThreshold && reading.overflow > collapsibleHeight
			 let expand = reading.offset <= collapseThreshold

			 if collapse, !isCollapsed{
				withAnimation(.easeInOut){ isCollapsed = true }
			 }else if expand, isCollapsed{
				withAnimation(.easeInOut){ isCollapsed = false }
			 }
		  }

		}
		.animation(.easeInOut, value: isCollapsed)
		.padding()
	 }
	 .sheet(isPresented: $vm.creationSheetActive){
		TodoCreationSheet()
	 }
	 .ignoresSafeArea(edges: .bottom)
	 .fontDesign(.monospaced)
  }
}

private struct ScrollReading: Equatable{
  let offset: CGFloat
  let overflow: CGFloat
}

#Preview {
  CalendarSheetView()
	 .environment(\.theme, .basic)
}


extension CalendarSheetView{
  private var Header: some View{
	 HStack{
		Button{
		  NavigationManager.shared.popSecondary()
		}label:{
		  Image(systemName: "chevron.left")
			 .font(.title3)
		}
		
		Text("Schedule Calendar")
		  .font(.title2)
		
		Spacer()
		Button{
		  vm.creationSheetActive = true
		}label:{
		  Image(systemName: "plus.circle")
			 .foregroundStyle(theme.text)
			 .font(.title.weight(.light))
		}
	 }
	 .foregroundStyle(theme.text)
  }
  
  private var Slider: some View{
	 HStack{
		Button{
		  withAnimation{
			 shift(-1)
		  }
		}label:{
		  Image(systemName: "chevron.left")
		}

		Text(sliderTitle)
		  .frame(maxWidth: .infinity)
		  .contentTransition(.numericText())

		Button{
		  withAnimation{
			 shift(1)
		  }
		}label:{
		  Image(systemName: "chevron.right")
		}
	 }
	 .foregroundStyle(theme.text)
  }
  private func shift(_ value: Int){
	 let component: Calendar.Component = isCollapsed ? .weekOfYear : .month
	 selectedMonth = Calendar.current.date(byAdding: component, value: value, to: selectedMonth) ?? selectedMonth
  }

  private var sliderTitle: String{
	 guard isCollapsed else {
		return selectedMonth.formatted(.dateTime.month(.wide))
	 }

	 let week = selectedMonth.weekDays
	 guard let first = week.first, let last = week.last else { return "" }

	 let format: Date.FormatStyle = .dateTime.day(.defaultDigits).month(.abbreviated)
	 return "\(first.formatted(format)) - \(last.formatted(format))"
  }
}
