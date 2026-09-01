//
//  LocationSelectionView.swift
//  Folovers
//
//  Created by user on 15.08.2026.
//

import SwiftUI

struct LocationSelectionView: View {
  @Environment(\.theme) var theme
  let planLocation: PlanLocation?
  let onPress: () -> ()
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
		  
		  Button{
			 withAnimation {
				onPress()
			 }
		  }label:{
			 if let planLocation{
				VStack{
				  MapFrameView(location: planLocation)
					 .clipShape(.rect(cornerRadius: 15))
					 .border(1)
				  Text(planLocation.name)
					 .font(.caption)
					 .multilineTextAlignment(.center)
				}
				.aspectRatio(1.3, contentMode: .fit)
			 }else{
				Image(systemName: "plus.circle")
				  .font(.largeTitle)
				  .frame(maxWidth: .infinity)
				  .padding(.vertical, 50)
				  .border()
			 }
		  }
		  
		  
		}
		.foregroundStyle(theme.primaryDark)
		.border(10)
    }
}

#Preview {
  LocationSelectionView(planLocation: nil){}
	 .environment(\.theme, .basic)
}
