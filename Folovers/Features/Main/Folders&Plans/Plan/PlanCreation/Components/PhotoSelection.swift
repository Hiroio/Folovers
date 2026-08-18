//
//  PhotoSelection.swift
//  Folovers
//
//  Created by user on 15.08.2026.
//

import SwiftUI

struct PhotoSelection: View {
  @State private var photoSelectorActive: Bool = false
  @State private var photos: [UIImage] = []
  @Environment(\.theme) var theme
  let photoAttachments: [PhotoAttachment]
  var body: some View {
	 VStack{
		HStack{
		  Text("Photo")
		  
		  Spacer()
		  
		  Image(systemName: "photo")
		}
		.font(.headline.weight(.bold))
		.padding(5)
		
		LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 10){
		  Button{
			 photoSelectorActive = true
		  }label:{
			 actionBtn(image: "photo", text: "Library")
		  }
		  
		  Button{
			 photoSelectorActive = true
		  }label:{
			 actionBtn(image: "camera", text: "Camera")
		  }
		  
		  if !photos.isEmpty{
			 ForEach(photos, id: \.self) { photo in
				Image(uiImage: photo)
				  .resizable()
				  .containerRelativeFrame(.horizontal, count: 3, spacing: 25)
				  .aspectRatio(1, contentMode: .fill)
				  .clipShape(.rect(cornerRadius: 15))
				  .border(0)
				  
			 }
		  }
		}
		.card(5)
		
	 }
	 .animation(.easeInOut, value: photos)
	 .foregroundStyle(theme.primaryDark)
	 .border(10)
	 .sheet(isPresented: $photoSelectorActive) {
		PhotoSelectorRepresentable { items in
		  self.photos = items
		}
	 }
  }
}

#Preview {
  PhotoSelection(photoAttachments: [])
	 .environment(\.theme, .basic)
}


extension PhotoSelection{
  func actionBtn(image: String, text: String) -> some View{
	 VStack{
		Image(systemName: image)
		  .font(.title2)
		Text(text)
		  .font(.footnote)
	 }
	 .fontDesign(.monospaced)
	 .foregroundStyle(theme.primaryDark)
	 .frame(maxWidth: .infinity, maxHeight: .infinity)
	 .aspectRatio(1, contentMode: .fit)
	 .card(15)
  }
}
