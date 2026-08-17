//
//  SecondaryScreen.swift
//  Folovers
//
//  Created by user on 17.08.2026.
//

import SwiftUI

struct SecondaryScreen: View {
  let secondaryScreen: SecondaryViewsEnum
  @Environment(\.theme) var theme
    var body: some View {
		ZStack{
		  theme.background.ignoresSafeArea()
		  switch secondaryScreen {
		  case .plan(let folderId):
			 PlansView(folderId: folderId)
		  }
		}
    }
}

#Preview {
  SecondaryScreen(secondaryScreen: .plan(folderId: ""))
}
