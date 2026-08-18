//
//  CreationPlanCard.swift
//  Folovers
//
//  Created by user on 17.08.2026.
//

import SwiftUI

struct CreationPlanCard: View {
  @Environment(\.theme) var theme
    var body: some View {
		VStack(spacing: 15){
		  Text("Create")
			 .font(.footnote)
			 .foregroundStyle(theme.primaryDark)
		  Spacer()
		  Image(systemName: "plus.circle")
			 .font(.largeTitle)
			 .foregroundStyle(theme.primaryDark)
		 
		  Spacer()
			 Text("Folovers")
			 .font(.title3.weight(.semibold))
			 .foregroundStyle(theme.primaryDark)
			 .opacity(0.5)
		}
		.fontDesign(.monospaced)
		.frame(maxWidth: .infinity)
		.card(15)
		.aspectRatio(1.2, contentMode: .fit)
    }
}

#Preview {
    CreationPlanCard()
	 .environment(\.theme, .basic)
}
