//
//  NoteBorder.swift
//  Folovers
//
//  Created by user on 15.08.2026.
//

import SwiftUI

struct NoteBorder: Shape {
  var cornerRadius: CGFloat = 15
  var toothCount: Int = 8
  var toothDepth: CGFloat = 12

  func path(in rect: CGRect) -> Path {
	 var path = Path()

	 let baseY = rect.maxY - toothDepth
	 let toothWidth = rect.width / CGFloat(toothCount)

	 path.move(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))

	 path.addArc(
		center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius),
		radius: cornerRadius,
		startAngle: .degrees(180),
		endAngle: .degrees(270),
		clockwise: false
	 )

	 path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))

	 path.addArc(
		center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius),
		radius: cornerRadius,
		startAngle: .degrees(270),
		endAngle: .degrees(0),
		clockwise: false
	 )

	 path.addLine(to: CGPoint(x: rect.maxX, y: baseY))

	 for i in 0..<toothCount {
		let rightX = rect.maxX - CGFloat(i) * toothWidth
		let midX = rightX - toothWidth / 2
		let leftX = rightX - toothWidth
		path.addLine(to: CGPoint(x: midX, y: rect.maxY))
		path.addLine(to: CGPoint(x: leftX, y: baseY))
	 }

	 path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))

	 path.closeSubpath()
	 return path
  }
}

#Preview {
  NoteBorder()
	 .fill(Color.red.opacity(0.1))
	 .overlay(
		NoteBorder()
		  .stroke(Color.red, style: .init(lineWidth: 2, lineCap: .round, lineJoin: .round))
	 )
	 .frame(width: 260, height: 180)
	 .padding()
}
