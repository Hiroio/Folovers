//
//  ThemePalette.swift
//  Folovers
//
//  Created by user on 13.08.2026.
//

import Foundation
import SwiftUI
import UIKit


struct ThemePalette{
  let background: Color
  let surface: Color
  let primary: Color
  let primaryDark: Color
  let text: Color
  let secondaryText: Color
}


extension ThemePalette{
  static var basic = ThemePalette(
	 background: Color("red-background"),
	 surface: Color("red-surface"),
	 primary: Color("red-primary"),
	 primaryDark: Color("red-primaryDark"),
	 text: Color("red-text"),
	 secondaryText: Color("red-secondaryText")
  )
}




