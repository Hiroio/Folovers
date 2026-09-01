//
//  TabShape.swift
//  Folovers
//
//  Created by user on 29.08.2026.
//

import SwiftUI


struct TabShape: Shape {
	 var topRadius: CGFloat = 14
	 var notchRadius: CGFloat = 12

	 func path(in rect: CGRect) -> Path {
		  var path = Path()
		  let w = rect.width
		  let h = rect.height

		  path.move(to: CGPoint(x: 0, y: h))

		  path.addCurve(
				to: CGPoint(x: notchRadius, y: h - notchRadius),
				control1: CGPoint(x: notchRadius * 0.55, y: h),
				control2: CGPoint(x: notchRadius, y: h - notchRadius * 0.55)
		  )

		  path.addLine(to: CGPoint(x: notchRadius, y: topRadius))

		  path.addArc(
				center: CGPoint(x: notchRadius + topRadius, y: topRadius),
				radius: topRadius,
				startAngle: .degrees(180), endAngle: .degrees(270),
				clockwise: false
		  )

		  path.addLine(to: CGPoint(x: w - notchRadius - topRadius, y: 0))

		  path.addArc(
				center: CGPoint(x: w - notchRadius - topRadius, y: topRadius),
				radius: topRadius,
				startAngle: .degrees(270), endAngle: .degrees(0),
				clockwise: false
		  )

		  path.addLine(to: CGPoint(x: w - notchRadius, y: h - notchRadius))

		  // дзеркальна увігнута крива праворуч
		  path.addCurve(
				to: CGPoint(x: w, y: h),
				control1: CGPoint(x: w - notchRadius, y: h - notchRadius * 0.55),
				control2: CGPoint(x: w - notchRadius * 0.55, y: h)
		  )

		  path.closeSubpath()
		  return path
	 }
}
