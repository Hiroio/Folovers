//
//  SystemPopUpView.swift
//  Folovers
//
//  Created by user on 27.08.2026.
//

import SwiftUI

struct SystemPopUpView: View {
  @Environment(\.theme) var theme
  let popUp: SystemPopUpModel
    var body: some View {
		HStack(spacing: 15){
		  Image(systemName: popUp.type.systemIcon)
			 .font(.title3)
			 .foregroundStyle(popUp.type.color)
		  
		  Text(popUp.text)
		  
		  
		  
		}
		.frame(maxWidth: .infinity)
		.padding()
		.background(
		  RoundedRectangle(cornerRadius: 15)
			 .fill(theme.background)
		)
		.border(color: popUp.type.color)
		.compositingGroup()
		.shadow(radius: 4)
		.padding(5)
		.fontDesign(.monospaced)
    }
}

#Preview {
  SystemPopUpView(popUp: .get(.success))
	 .environment(\.theme, .basic)
}
