//
//  MaleIcon.swift
//  Folovers
//
//  Created by user on 14.08.2026.
//

import Foundation
import SwiftUI


struct MaleIcon: Shape {
  func path(in rect: CGRect) -> Path {
	 var path = Path()

	 let size = min(rect.width, rect.height)
	 let inset = size * 0.06
	 let circleRadius = size * 0.30
	 let barbLength = size * 0.30
	 let barbAngle = Angle(degrees: 40)

	 let tip = CGPoint(x: rect.maxX - inset, y: rect.minY + inset)
	 let circleCenter = CGPoint(x: rect.minX + inset + circleRadius, y: rect.maxY - inset - circleRadius)

	 let direction = CGPoint(x: tip.x - circleCenter.x, y: tip.y - circleCenter.y)
	 let length = (direction.x * direction.x + direction.y * direction.y).squareRoot()
	 let unit = CGPoint(x: direction.x / length, y: direction.y / length)

	 let shaftStart = CGPoint(x: circleCenter.x + unit.x * circleRadius, y: circleCenter.y + unit.y * circleRadius)

	 func rotated(_ vector: CGPoint, by angle: Angle) -> CGPoint {
		let radians = angle.radians
		let cosA = cos(radians)
		let sinA = sin(radians)
		return CGPoint(x: vector.x * cosA - vector.y * sinA, y: vector.x * sinA + vector.y * cosA)
	 }

	 let reverse = CGPoint(x: -unit.x, y: -unit.y)
	 let barb1 = rotated(reverse, by: barbAngle)
	 let barb2 = rotated(reverse, by: -barbAngle)

	 path.addEllipse(in: CGRect(x: circleCenter.x - circleRadius, y: circleCenter.y - circleRadius, width: circleRadius * 2, height: circleRadius * 2))

	 path.move(to: shaftStart)
	 path.addLine(to: tip)

	 path.move(to: tip)
	 path.addLine(to: CGPoint(x: tip.x + barb1.x * barbLength, y: tip.y + barb1.y * barbLength))

	 path.move(to: tip)
	 path.addLine(to: CGPoint(x: tip.x + barb2.x * barbLength, y: tip.y + barb2.y * barbLength))

	 return path
  }
}



#Preview {
  MaleIcon()
	 .stroke(.blue, style: .init(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
	 .frame(width: 20, height: 20)
}
