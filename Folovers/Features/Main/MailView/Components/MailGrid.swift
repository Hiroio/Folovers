//
//  MailGrid.swift
//  Folovers
//
//  Created by user on 26.08.2026.
//

import SwiftUI

struct MailGrid: View {
  @Environment(\.theme) var theme
  @Bindable var vm: MailViewModel

	 var body: some View {
		ZStack{
		  if vm.letters.isEmpty{
			 VStack(spacing: 10){
				Image(systemName: vm.mailState.icon)
				  .font(.largeTitle)

				Text(vm.mailState.emptyText)
				  .font(.subheadline)
			 }
			 .foregroundStyle(theme.secondaryText)
			 .frame(maxWidth: .infinity, maxHeight: .infinity)
			 .transition(.opacity)
		  }else{
			 ScrollView(showsIndicators: false){
				LazyVStack(spacing: 10){
				  ForEach(vm.letters){item in
					 LetterItemGrid(
						letter: item,
						user: vm.counterpart(for: item),
						incoming: vm.mailState == .received
					 )
					 .onTapGesture {
						withAnimation{
						  vm.open(letter: item)
						}
					 }
				  }
				}
				.padding(1)
			 }
			 .transition(vm.mailState.transition)
		  }
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
  ZStack{
	 ThemePalette.basic.background.ignoresSafeArea()
	 MailGrid(vm: MailViewModel())
		.environment(\.theme, .basic)
		.fontDesign(.monospaced)
  }
}
