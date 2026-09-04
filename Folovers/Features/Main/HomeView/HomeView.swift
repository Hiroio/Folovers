//
//  HomeView.swift
//  Folovers
//
//  Created by user on 20.08.2026.
//

import SwiftUI

struct HomeView: View {
  @Environment(\.theme) var theme
  @State private var vm = HomeViewModel()
  var body: some View {
	 VStack{
		HomeHeader
		
		VStack{
		  VStack(spacing: 35){
			 SpriteView(
				action: vm.spriteAction,
				config: vm.user?.characterConfig,
				size: CGSize(width: 128, height: 128)
			 )
			 
			 MoodBar(mood: vm.mood){ item in
				withAnimation{
				  vm.changeMood(to: item)
				}
			 }
		  }
		  
		  Spacer()
		  
		  VStack{
			 Button{
				withAnimation(.bouncy) {
				  vm.calendarActive.toggle()
				}
			 }label:{
				HStack{
				  Text("Calendar")
					 .frame(maxWidth: .infinity, alignment: .leading)
				  
				  Image(systemName: "calendar")
				  
				  Image(systemName: "chevron.right")
					 .rotationEffect(Angle(degrees: vm.calendarActive ? 90 : 0))
				  
				}
				.padding(5)
				.foregroundStyle(theme.primary)
			 }
			 
			 if vm.calendarActive{
				CalendarView(month: .constant(.now), selectedDay: .constant(.now))
				  .transition(.scale(0, anchor: .bottom).combined(with: .opacity))
				  .disabled(true)
				
				Button{
				  NavigationManager.shared.addSecondary(.calendar)
				}label:{
				  Text("Calendar")
					 .foregroundStyle(theme.primary)
					 .frame(maxWidth: .infinity)
					 .border(15, dashed: true)
				}
			 }
			 
		  }
		  .card(10)
		}
		.frame(maxHeight: .infinity, alignment: .top)
	 }
	 .frame(maxHeight: .infinity)
	 .padding()
	 .fontDesign(.monospaced)
  }
}

#Preview {
  ZStack{
	 ThemePalette.basic.background.ignoresSafeArea()
	 HomeView()
		.environment(\.theme, .basic)
  }
}

extension HomeView{
  private var HomeHeader: some View{
	 HStack{
		VStack(alignment: .leading){
		  Text("Home")
			 .font(.title2)
			 .foregroundStyle(theme.text)
		  Text("your home page")
			 .font(.caption)
			 .foregroundStyle(theme.secondaryText)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		
		Button{
		  NavigationManager.shared.addPopUp(.mailBox)
		}label:{
		  let image = vm.unReadMessages > 0 ? "EnvelopeSealed" : "EnvelopeOpen"
		  Image(image)
			 .resizable()
			 .scaledToFit()
			 .containerRelativeFrame(.horizontal, count: 6, spacing: 30)
			 .overlay(alignment: .topLeading){
				Text("\(vm.unReadMessages)")
				  .foregroundStyle(.white)
				  .font(.headline.weight(.bold))
				  .padding(8)
				  .background(
					 Circle()
						.fill(theme.primary)
				  )
				  .opacity(vm.unReadMessages > 0 ? 1 : 0)
				  .offset(x: -1, y: -10)
			 }
		}
	 }
  }
}
