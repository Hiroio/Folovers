//
//  FemaleIcon.swift
//  Folovers
//
//  Created by user on 14.08.2026.
//

import Foundation
import SwiftUI


struct FemaleIcon: Shape{
  func path(in rect: CGRect) -> Path {
	 var path = Path()
	 let widthHalf = rect.width / 2
	 
	 path.addArc(center: CGPoint(x: rect.midX, y: rect.midY - widthHalf / 2), radius: widthHalf * 0.7, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
	 let savedPoint = path.currentPoint ?? .zero
	 
	 path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY * 1.1))
	 path.move(to: CGPoint(x: rect.midX + widthHalf / 2, y: rect.maxY - (rect.height / 9)))
	 path.addLine(to: CGPoint(x: rect.midX - widthHalf / 2, y: rect.maxY - (rect.height / 9)))
	 path.move(to: savedPoint)
	 
	 path.addArc(center: CGPoint(x: rect.midX, y: rect.midY - widthHalf / 2), radius: widthHalf * 0.7, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 360), clockwise: false)
	 
	 return path
  }
}


#Preview {
  HStack{
	 Group{
		FemaleIcon()
		  .stroke(style: .init(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
		MaleIcon()
		  .stroke(style: .init(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
	 }
	 .frame(width: 20, height: 20)
	 .scaledToFit()
	 .padding(10)
	 .background(
		RoundedRectangle(cornerRadius: 15)
		  .stroke(style: .init(lineWidth: 2))
	 )
	 .foregroundStyle(.red)
  }
}
