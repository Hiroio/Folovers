//
//  TodoCreationSheet.swift
//  Folovers
//
//  Created by user on 01.09.2026.
//

import SwiftUI

struct TodoCreationSheet: View {
  @Environment(\.dismiss) var dismiss
  @Environment(\.theme) var theme
  @Namespace var nm
  @State private var vm = TodoCreationViewModel()
  @State private var colorSelection: Bool = true
  @FocusState var focusState: Bool
  var body: some View {
	 ZStack{
		let palette = vm.todoColor.palette
		palette.background.ignoresSafeArea()
		
		VStack{
		  HStack(alignment: .top){
			 VStack(alignment: .leading){
				Text("Title")
				  .font(.footnote.weight(.bold))
				TextField("", text: $vm.title)
				  .padding()
				  .background(
					 RoundedRectangle(cornerRadius: 15)
						.fill(palette.surface)
						.shadow(radius: 1)
				  )
				  .border(color: palette.primary)
				  .focused($focusState)
				  .background(alignment: .topLeading){
					 if focusState && !vm.similarTodos.isEmpty{
						SimilarTodosList(todos: vm.similarTodos, palette: vm.todoColor.palette){item in
						  focusState = false
						  withAnimation{
							 vm.getPreset(todo: item)
						  }
						}
						.offset(y: focusState ? 45 : 0)
						.transition(.scale(0, anchor: .topLeading))
						.allowsHitTesting(focusState)
					 }
				  }
				
				NoteSection
				  .zIndex(-1)
				
				DateSection
				  .zIndex(-1)
			 }
			 
			 VStack{
				ColorSelection()
				  .frame(maxHeight: .infinity, alignment: .top)
				
				privacySwitch()
			 }
			 
		  }
		  
		  
		  Spacer()
		  Button{
			 vm.createTodo()
			 dismiss()
		  }label:{
			 Text("Create")
				.foregroundStyle(palette.primaryDark)
				.frame(maxWidth: .infinity)
				.border(15,lineWidth: 3, color: palette.primary)
				.padding()
			 
		  }
		}
		.animation(.easeInOut, value: focusState)
		.frame(maxHeight: .infinity, alignment: .top)
		.padding()
		.background(
		  UnevenRoundedRectangle(cornerRadii: .init(topLeading: 40, bottomLeading: 60, bottomTrailing: 60, topTrailing: 40))
			 .stroke(vm.todoColor.palette.primary, lineWidth: 5)
			 .ignoresSafeArea(edges: .bottom)
		)
		.padding(1)
		.fontDesign(.monospaced)
	 }
	 
	 .ignoresSafeArea(edges: .bottom)
  }
}


#Preview {
  ZStack{}
	 .sheet(isPresented: .constant(true)){
		TodoCreationSheet()
		  .presentationDetents([.medium])
	 }
}


extension TodoCreationSheet{
  private var DateSection: some View{
	 VStack(alignment: .leading){
		Text("Date")
		  .font(.footnote.weight(.bold))
		  .foregroundStyle(vm.todoColor.palette.text)
		
		if vm.date == nil{
		  Button{
			 withAnimation{
				vm.date = .now
			 }
		  }label:{
			 HStack{
				Image(systemName: "calendar.badge.plus")
				Text("Today")
				  .padding(5)
				  .padding(.horizontal)
				  .background(
					 RoundedRectangle(cornerRadius: 10)
						.fill(vm.todoColor.palette.primary.opacity(0.2))
				  )
				  .frame(maxWidth: .infinity, alignment: .trailing)
			 }
			 .font(.footnote.weight(.semibold))
			 .frame(maxWidth: .infinity, alignment: .leading)
			 .padding(12)
			 .background(
				RoundedRectangle(cornerRadius: 15)
				  .fill(vm.todoColor.palette.surface)
			 )
		  }
		}else{
		  HStack{
			 DatePicker("", selection: dateBinding, displayedComponents: [.date, .hourAndMinute])
				.labelsHidden()
			 
			 Spacer()
			 
			 Button{
				withAnimation{
				  vm.date = nil
				}
			 }label:{
				Image(systemName: "xmark.circle.fill")
			 }
		  }
		  .padding(8)
		  .background(
			 RoundedRectangle(cornerRadius: 15)
				.fill(vm.todoColor.palette.surface)
		  )
		}
	 }
	 .foregroundStyle(vm.todoColor.palette.primaryDark)
	 .tint(vm.todoColor.palette.primary)
  }
  
  
  private var dateBinding: Binding<Date>{
	 Binding {
		vm.date ?? .now
	 } set: { newValue in
		vm.date = newValue
	 }
  }
  
  private var NoteSection: some View{
	 VStack(alignment: .leading){
		Text("Note")
		  .font(.footnote.weight(.bold))
		TextEditor(text: $vm.note)
		  .scrollContentBackground(.hidden)
		  .font(.footnote.weight(.bold))
		  .lineSpacing(5)
		  .foregroundStyle(theme.primaryDark)
		  .padding(5)
		  .padding(.bottom)
		  .background(
			 NoteBorder()
				.fill(vm.todoColor.palette.background)
		  )
		  .overlay {
			 NoteBorder()
				.stroke(vm.todoColor.palette.primaryDark, style: .init(lineWidth: 2, lineCap: .round, lineJoin: .round))
		  }
	 }
  }
}


extension TodoCreationSheet{
  @ViewBuilder
  func ColorSelection() -> some View{
	 ZStack{
		if colorSelection{
		  VStack{
			 ForEach(AppThemeColor.allCases, id: \.self){item in
				Button{
				  withAnimation{
					 vm.todoColor = item
					 colorSelection = false
				  }
				}label:{
				  Circle()
					 .fill(item.palette.primary)
					 .frame(width: 50)
				}
			 }
		  }
		  .transition(.scale(0, anchor: .top).combined(with: .opacity))
		}else{
		  Button{
			 withAnimation{
				colorSelection = true
			 }
		  }label:{
			 Circle()
				.fill(vm.todoColor.palette.primary)
				.frame(width: 50)
		  }
		  .transition(.scale(0, anchor: .top).combined(with: .opacity))
		}
	 }
  }
  
  
  @ViewBuilder
  func privacySwitch() -> some View{
	 VStack{
		Text("Privacy")
		  .font(.caption.weight(.semibold))
		Button{
		  withAnimation(.linear){
			 vm.privacy = vm.privacy == .private ? .public : .private
		  }
		}label:{
		  VStack{
			 ForEach(TodoPrivacy.allCases, id: \.self){ item in
				let active = item == vm.privacy
				ZStack{
				  if active{
					 Image(systemName: item.icon)
						.foregroundStyle(active ? vm.todoColor.palette.primary : vm.todoColor.palette.secondaryText)
				  }
				  
				}
			 }
		  }
		}
		.padding(15)
		.background(
		  RoundedRectangle(cornerRadius: 10)
			 .fill(vm.todoColor.palette.surface)
		)
		
	 }
  }
  
  
  
  
}
