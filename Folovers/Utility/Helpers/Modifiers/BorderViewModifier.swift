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
  let dashed: Bool
  let color: Color?
  func body(content: Content) -> some View {
	 content
		.padding(padding)
		.background(
		  RoundedRectangle(cornerRadius: 15)
			 .stroke(color ?? theme.primary, style: .init(lineWidth: lineWidth, lineCap: .round, lineJoin: .round, dash: [dashed ? 10 : 1]))
		)
  }
}

struct CardViewModifier: ViewModifier{
  @Environment(\.theme) var theme
  let padding: CGFloat
  let lineWidth: CGFloat
  let dashed: Bool
  let themePalette: ThemePalette?
  func body(content: Content) -> some View {
	 let pallete = themePalette ?? theme
	 content
		.padding(padding)
		.background(
		  RoundedRectangle(cornerRadius: 15)
			 .fill(pallete.surface)
		)
		.border(lineWidth: lineWidth, dashed: dashed, color: pallete.primary)
  }
}


extension View{
  func border(_ padding: CGFloat = 0, lineWidth: CGFloat = 2, dashed: Bool = false, color: Color? = nil) -> some View{
	 modifier(BorderViewModifier(padding: padding, lineWidth: lineWidth, dashed: dashed, color: color))
  }
  
  func card(_ padding: CGFloat = 0, lineWidth: CGFloat = 2, dashed: Bool = false, palette: ThemePalette? = nil) -> some View{
	 modifier(CardViewModifier(padding: padding, lineWidth: lineWidth, dashed: dashed, themePalette: palette))
  }
}
