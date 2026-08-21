//
//  AppThemeColor.swift
//  Folovers
//
//  Created by user on 13.08.2026.
//

import Foundation
import SwiftUI


enum AppThemeColor: String, CaseIterable, Codable {
	 case red, blue, green, yellow

	 var palette: ThemePalette {
		ThemePalette(
		  background: Color("\(self.rawValue)-background"),
		  surface: Color("\(self.rawValue)-surface"),
		  primary: Color("\(self.rawValue)-primary"),
		  primaryDark: Color("\(self.rawValue)-primaryDark"),
		  text: Color("\(self.rawValue)-text"),
		  secondaryText: Color("\(self.rawValue)-secondaryText")
		)
	 }
}



private struct ThemeKey: EnvironmentKey {
	 static let defaultValue = AppThemeColor.red.palette
}
extension EnvironmentValues {
	 var theme: ThemePalette {
		  get { self[ThemeKey.self] }
		  set { self[ThemeKey.self] = newValue }
	 }
}
