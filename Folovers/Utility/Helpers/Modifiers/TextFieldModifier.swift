//
//  TextFieldModifier.swift
//  Folovers
//
//  Created by user on 13.08.2026.
//

import Foundation
import SwiftUI

struct TextFieldModifier: ViewModifier {
  @Environment(\.theme) var theme
  let light: Bool
  func body(content: Content) -> some View {
	 content
		.foregroundStyle(theme.primary)
		.frame(maxWidth: .infinity)
		.padding()
		.background(
		  RoundedRectangle(cornerRadius: 15)
			 .fill((light ? Color.white : Color.gray).opacity(0.2))
		)
		.fontDesign(.monospaced)
  }
}


extension View{
  func textFieldModifier(light: Bool = false) -> some View {
	 modifier(TextFieldModifier(light: light))
  }
}
