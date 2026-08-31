//
//  SpriteActions.swift
//  Folovers
//
//  Created by user on 11.08.2026.
//

import Foundation


enum SpriteActions{
  case idle, walk, jump, loading, idleLoading, preview, angry, sad, happy, awkward
  
  
  var sprites: Int {
	 switch self {
	 case .idle:
		0
	 case .walk:
		30
	 case .jump:
		10
	 case .loading:
		8
	 case .idleLoading:
		0
	 case .preview:
		0
	 case .angry:
		8
	 case .sad:
		4
	 case .happy:
		6
	 case .awkward:
		10
	 }
  }
  
  var animationDuration: Double{
	 switch self {
	 case .jump:
		0.85
	 case .idleLoading:
		1
	 case .preview:
		0
	 case .happy:
		0.85
	 default:
		0.6
	 }
  }
  
  func xPosition(step: Int, containerWidth: CGFloat, spriteWidth: CGFloat) -> CGFloat {
	 let half = containerWidth / 2 + 96
	 switch self {
	 case .walk:
		let start = 0.0
		let value = (containerWidth + 96) / Double(sprites)
		return CGFloat(start + value * Double(step))
	 case .jump:
		let start = 0.0
		let value = (containerWidth + 96) / Double(sprites)
		return CGFloat(start + value * Double(step))
	 case .loading:
		let start = -96.0
		let value = Double(half / Double(sprites))
		return CGFloat(start + Double(step) * value)
	 case .happy:
		let start = half
		let value = containerWidth / Double(sprites)
		return CGFloat(start + (value * Double(step - sprites / 2)))
		
	 default:
		return half
	 }
  }
}

