//
//  PhotoSelection.swift
//  Folovers
//
//  Created by user on 15.08.2026.
//

import SwiftUI

struct PhotoSelection: View {
  @Environment(\.theme) var theme
    var body: some View {
		VStack{
		  HStack{
			 Text("Photo")
			 
			 Spacer()
			 
			 Image(systemName: "photo")
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
    PhotoSelection()
	 .environment(\.theme, .basic)
}
