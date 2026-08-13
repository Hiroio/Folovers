//
//  ThemeManager.swift
//  Folovers
//
//  Created by user on 13.08.2026.
//

import Foundation


@MainActor
@Observable
final class ThemeManager {
	 static let shared = ThemeManager()

	 var selectedColor: AppThemeColor {
		  didSet { UserDefaults.standard.set(selectedColor.rawValue, forKey: "themeColor") }
	 }

	 var palette: ThemePalette { selectedColor.palette }

	 private init() {
		  if let raw = UserDefaults.standard.string(forKey: "themeColor"),
			  let saved = AppThemeColor(rawValue: raw) {
				selectedColor = saved
		  } else {
				selectedColor = .red
		  }
	 }
}
