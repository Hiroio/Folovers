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
  let lineWidth: CGFloat
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
  let lineWidth: CGFloat
  func body(content: Content) -> some View {
	 content
		.padding(padding)
		.background(
		  RoundedRectangle(cornerRadius: 15)
			 .fill(theme.surface)
		)
		.border(lineWidth: lineWidth)
  }
}


extension View{
  func border(_ padding: CGFloat = 0, lineWidth: CGFloat = 2) -> some View{
	 modifier(BorderViewModifier(padding: padding, lineWidth: lineWidth))
  }
  
  func card(_ padding: CGFloat = 0, lineWidth: CGFloat = 2) -> some View{
	 modifier(CardViewModifier(padding: padding, lineWidth: lineWidth))
  }
}
