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
  func body(content: Content) -> some View {
	 content
		.foregroundStyle(theme.primary)
		.frame(maxWidth: .infinity)
		.padding()
		.background(
		  RoundedRectangle(cornerRadius: 15)
			 .fill(.gray.opacity(0.2))
		)
		.fontDesign(.monospaced)
  }
}


extension View{
  func textFieldModifier() -> some View {
	 modifier(TextFieldModifier())
  }
}
