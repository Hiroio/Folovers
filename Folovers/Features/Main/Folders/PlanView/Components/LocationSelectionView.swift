//
//  LocationSelectionView.swift
//  Folovers
//
//  Created by user on 15.08.2026.
//

import SwiftUI

struct LocationSelectionView: View {
  @Environment(\.theme) var theme
    var body: some View {
		VStack{
		  HStack{
			 Text("Location")
			 
			 Spacer()
			 
			 ZStack(alignment: .top){
				Circle()
				  .stroke(lineWidth: 2)
				  .frame(width: 4)
				  .padding(.top, 5.5)
				Image(systemName: "drop")
				  .rotationEffect(Angle(degrees: 180))
			 }
		  }
		  .font(.headline.weight(.bold))
		  .padding(5)
		  
		  Image(systemName: "plus.circle")
			 .font(.largeTitle)
			 .frame(maxWidth: .infinity)
			 .padding(.vertical, 50)
			 .border()
		  
		  
		}
		.foregroundStyle(theme.primaryDark)
		.border(10)
    }
}

#Preview {
    LocationSelectionView()
	 .environment(\.theme, .basic)
}
