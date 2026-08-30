//
//  ColorSelectionBar.swift
//  Folovers
//
//  Created by user on 30.08.2026.
//

import SwiftUI

struct ColorSelectionBar: View {
  @Binding var color: AppThemeColor
    var body: some View {
		LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 15), count: 6)){
		  ForEach(AppThemeColor.allCases, id: \.rawValue){item in
			 let active = item == color
			 Button{
				withAnimation{
				  color = item
				}
			 }label:{
				Circle()
				  .fill(active ? item.palette.primary.opacity(0.8) : item.palette.surface)
				  .padding(1)
				  .background(
					 Circle()
						.stroke(active ? item.palette.primaryDark : .clear, lineWidth: 3)
				  )
			 }
		  }
		}
    }
}

#Preview {
  @Previewable @State var color: AppThemeColor = .red
  ColorSelectionBar(color: $color)
}
