//
//  BorderViewModifier.swift
//  Folovers
//
//  Created by user on 14.08.2026.
//

import Foundation
import SwiftUI

struct BorderViewModifier: ViewModifier{
  @Environment(\.theme) var theme
  let padding: CGFloat
  func body(content: Content) -> some View {
	 content
		.padding(padding)
		.background(
		  RoundedRectangle(cornerRadius: 15)
			 .stroke(theme.primary, lineWidth: 2)
		)
  }
}

struct CardViewModifier: ViewModifier{
  @Environment(\.theme) var theme
  let padding: CGFloat
  func body(content: Content) -> some View {
	 content
		.padding(padding)
		.background(
		  RoundedRectangle(cornerRadius: 15)
			 .fill(theme.surface)
		)
		.border()
  }
}


extension View{
  func border(_ padding: CGFloat = 0) -> some View{
	 modifier(BorderViewModifier(padding: padding))
  }
  
  func card(_ padding: CGFloat = 0) -> some View{
	 modifier(CardViewModifier(padding: padding))
  }
}
