//
//  MailView.swift
//  Folovers
//
//  Created by user on 26.08.2026.
//

import SwiftUI

struct MailView: View {
  @Environment(\.theme) var theme
  @State private var vm = MailViewModel()
    var body: some View {
		VStack(spacing: 10){
		  Text("Mail Box")
			 .font(.title2.weight(.bold))
			 .foregroundStyle(theme.primaryDark)

		  Rectangle()
			 .fill(theme.primary.opacity(0.4))
			 .frame(height: 2)

		  MailPicker(state: $vm.mailState, unreadCount: vm.unreadCount)

//		  GRID
		  MailGrid(vm: vm)

		  Rectangle()
			 .fill(theme.primary.opacity(0.7))
			 .frame(height: 2)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.card(10)
		.fontDesign(.monospaced)
		.aspectRatio(0.8, contentMode: .fit)
		.padding()
    }
}

#Preview {
    MailView()
}
