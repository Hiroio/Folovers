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
		.fontDesign(.monospaced)
		.frame(maxWidth: .infinity)
		.padding()
		.background(
		  RoundedRectangle(cornerRadius: 15)
			 .stroke(theme.primary, lineWidth: 2)
			 .shadow(color: configuration.isPressed ? .clear : theme.primary, radius: 1, y: 1)
		)
		.offset(y: configuration.isPressed ? 5 : 0)
  }
}


