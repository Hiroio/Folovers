//
//  CustomToggle.swift
//  Folovers
//
//  Created by user on 29.09.2026.
//

import SwiftUI

struct CustomToggle: View {
  @Environment(\.theme) var theme
  @Binding var isOn: Bool
    var body: some View {
		GeometryReader{geo in
		  Button{
			 withAnimation(){
				isOn.toggle()
			 }
		  }label:{
			 ZStack(alignment: isOn ? .trailing : .leading){
				RoundedRectangle(cornerRadius: 12)
				  .stroke(theme.primaryDark, lineWidth: 2)
				
				if isOn{
				  RoundedRectangle(cornerRadius: 12)
					 .fill(theme.surface)
				}
				
				RoundedRectangle(cornerRadius: 10)
				  .fill(theme.primary)
				  .frame(width: geo.size.width / 2.1)
				  .padding(5)
				
				
			 }
		  }
		}
		.aspectRatio(2, contentMode: .fit)
    }
}

#Preview {
  CustomToggle(isOn: .constant(false))
	 .environment(\.theme, .basic)
}
