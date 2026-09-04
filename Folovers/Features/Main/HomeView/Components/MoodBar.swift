//
//  MoodBar.swift
//  Folovers
//
//  Created by user on 31.08.2026.
//

import SwiftUI

struct MoodBar: View {
  @Environment(\.theme) var theme
	let mood: CharacterMood?
  let onChange: (CharacterMood) -> ()
  var body: some View {
	 HStack{
		ForEach(CharacterMood.allCases){item in
		  let active = item == mood
		  Button{
			 onChange(item)
		  }label:{
			 Image(item.rawValue)
				.resizable()
				.scaledToFit()
				.border(5, lineWidth: 3, color: active ? theme.primary : theme.secondaryText)
				.shadow(radius: 2, x: -5)
				.opacity(active ? 1 : 0.7)
				.scaleEffect(active ? 1 : 0.9)
		  }
		}
	 }
  }
}

#Preview {
  MoodBar(mood: .happy){_ in}
	 .environment(\.theme, .basic)
}


enum CharacterMood: String, Codable, Identifiable, CaseIterable{
  case sad, surprised, happy, awkward, angry
  
  
  var id: String{
	 self.rawValue
  }
  
  var actions: SpriteActions{
	 return switch self {
	 case .sad:
		  .sad
	 case .surprised:
		  .idle
	 case .happy:
		  .happy
	 case .awkward:
		  .awkward
	 case .angry:
		  .angry
	 }
  }
}
