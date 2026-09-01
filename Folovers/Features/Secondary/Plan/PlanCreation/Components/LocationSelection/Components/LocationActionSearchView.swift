//
//  LocationActionSearchView.swift
//  Folovers
//
//  Created by user on 19.08.2026.
//

import SwiftUI
import MapKit

struct LocationActionSearchView: View {
  @Environment(\.theme) var theme
  @Bindable var vm: LocationSearchViewModel

  var body: some View {
	 VStack(spacing: 10){
		TextField("", text: $vm.searchText, prompt:
						Text("Name of the place")
		  .foregroundStyle(theme.secondaryText)
		)
		.textFieldModifier()

		HStack{
		  TextField("", text: $vm.latText, prompt:
						  Text("52.130508")
			 .foregroundStyle(theme.secondaryText)
		  )
		  .textFieldModifier()
		  .keyboardType(.numbersAndPunctuation)

		  TextField("", text: $vm.lonText, prompt:
						  Text("-6.932005")
			 .foregroundStyle(theme.secondaryText)
		  )
		  .textFieldModifier()
		  .keyboardType(.numbersAndPunctuation)

		  Button{
			 vm.pasteCoordinates()
		  }label:{
			 Image(systemName: "rectangle.on.rectangle")
				.foregroundStyle(theme.primary)
				.border(15)
		  }
		}

		ScrollView{
		  LazyVStack(alignment: .leading, spacing: 10){
			 ForEach(vm.results){ candidate in
				Button{
				  vm.selectCandidate(candidate)
				}label:{
				  VStack(alignment: .leading, spacing: 2){
					 Text(candidate.title)
						.font(.subheadline.weight(.semibold))
					 if !candidate.subtitle.isEmpty{
						Text(candidate.subtitle)
						  .font(.caption)
						  .foregroundStyle(theme.secondaryText)
					 }
				  }
				  .frame(maxWidth: .infinity, alignment: .leading)
				}
			 }
		  }
	 	}
	 }
  }
}

#Preview {
  LocationActionSearchView(vm: LocationSearchViewModel())
	 .environment(\.theme, .basic)
}
