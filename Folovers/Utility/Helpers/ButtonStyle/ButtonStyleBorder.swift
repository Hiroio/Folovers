//
//  ButtonStyleBorder.swift
//  Folovers
//
//  Created by user on 13.08.2026.
//

import Foundation
import SwiftUI


struct ButtonStyleBorder: ButtonStyle {
  @Environment(\.theme) var theme
  func makeBody(configuration: Self.Configuration) -> some View {
	 configuration.label
		.foregroundStyle(theme.primary)
		.font(.headline.weight(.bold))
		.fontDesign(.monospaced)
		.padding()
		.background(
		  RoundedRectangle(cornerRadius: 15)
			 .stroke(theme.primary, lineWidth: 2)
			 .shadow(color: configuration.isPressed ? .clear : theme.primary, radius: 1, y: 1)
		)
		.offset(y: configuration.isPressed ? 5 : 0)
		.contentShape(.rect)
  }
}


