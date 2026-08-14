//
//  ItemsSelection.swift
//  Folovers
//
//  Created by user on 14.08.2026.
//

import SwiftUI
import SpritePackage

struct ItemsSelection<T: SpritePackage.Styles>: View {
  @Environment(\.theme) var theme
  let selectedItem: T?
  let action: (T) -> ()
  init(selectedItem: T?, action: @escaping (T) -> ()){
	 self.selectedItem = selectedItem
	 self.action = action
  }
    var body: some View {
		VStack(alignment: .leading){
		  Text(T.title)
			 .font(.footnote.weight(.semibold))
			 .fontDesign(.monospaced)
			 .foregroundStyle(theme.primary)
		  
		  ScrollView(.horizontal){
			 HStack{
				ForEach(Array(T.allCases)){item in
				  let selected = item.id == selectedItem?.id
				  Button{
					 action(item)
				  }label: {
					 itemCard(item: item.id)
						.overlay{
						  ZStack{
							 if selected{
								Image(systemName: "checkmark.circle")
								  .font(.title)
								  .foregroundStyle(theme.primary)
							 }
						  }
						}
				  }
				}
			 }
			 .animation(.easeInOut, value: selectedItem?.id)
		  }
		}
    }
}

#Preview {
  ItemsSelection<BottomStyle>(selectedItem: BottomStyle.bottom){ _ in}
	 .environment(\.theme, .basic)
}

extension ItemsSelection{
  @ViewBuilder
  func itemCard(item: String) -> some View{
	 Text(item)
		.font(.title2)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.aspectRatio(1, contentMode: .fit)
		.card(20)
		.containerRelativeFrame(.horizontal, count: 3, spacing: 12)
		.padding(1)
		.foregroundStyle(theme.primary)
  }
}
