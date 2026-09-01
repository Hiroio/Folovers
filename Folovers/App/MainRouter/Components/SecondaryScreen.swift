//
//  SecondaryScreen.swift
//  Folovers
//
//  Created by user on 17.08.2026.
//

import SwiftUI

struct SecondaryScreen: View {
  let screen: SecondaryViewsEnum
  @Environment(\.theme) var theme
    var body: some View {
		ZStack{
		  theme.background.ignoresSafeArea()
		  switch screen {
		  case .plans(let folder):
			 PlansView(folder: folder)
				.transition(screen.transition)
		  case .calendar:
			 CalendarSheetView()
		  }
		}
		.animation(.easeInOut, value: screen.id)
    }
}

#Preview {
  SecondaryScreen(screen: .plans(folder: .personal))
}
