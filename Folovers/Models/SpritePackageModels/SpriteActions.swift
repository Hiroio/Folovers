//
//  SpriteActions.swift
//  Folovers
//
//  Created by user on 11.08.2026.
//

import Foundation


enum SpriteActions{
  case idle, walk, jump, loading
  
  
  var sprites: Int {
	 switch self {
	 case .idle:
		0
	 case .walk:
		30
	 case .jump:
		10
	 case .loading:
		10
	 }
  }
  
  var animationDuration: Double{
	 switch self {
	 case .idle:
		0.6
	 case .walk:
		0.6
	 case .jump:
		0.85
	 case .loading:
		0.6
	 }
  }
  
  func xPosition(step: Int, containerWidth: CGFloat, spriteWidth: CGFloat) -> CGFloat {
	 let half = containerWidth / 2 + 48
	 switch self {
	 case .idle:
		return 0
	 case .walk:
		let start = 0.0
		let value = (containerWidth + 96) / Double(sprites)
		return CGFloat(start + value * Double(step))
	 case .jump:
		let start = 0.0
		let value = (containerWidth + 96) / Double(sprites)
		return CGFloat(start + value * Double(step))
	 case .loading:
		let start = 0.0
		let value = Double(half / Double(sprites))
		return CGFloat(start + Double(step) * value)
	 }
  }
}

