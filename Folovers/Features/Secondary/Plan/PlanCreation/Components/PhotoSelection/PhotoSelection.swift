//
//  PhotoSelection.swift
//  Folovers
//
//  Created by user on 15.08.2026.
//

import SwiftUI
import Kingfisher

struct PhotoSelection: View {
  @Environment(\.theme) var theme
  @State private var photoSelectorActive: Bool = false
  @Binding var photos: [UIImage]
  @Binding var photoAttachments: [PhotoAttachment]
  let creation: Bool
  

  init(photos: Binding<[UIImage]>, photoAttachments: Binding<[PhotoAttachment]>, creation: Bool = true) {
	 self._photos = photos
	 self._photoAttachments = photoAttachments
	 self.creation = creation
  }
  var body: some View {
	 VStack{
		HStack{
		  Text("Photo")
		  
		  Spacer()
		  
		  Image(systemName: "photo")
		}
		.font(.headline.weight(.bold))
		.padding(5)
		
		if !creation && photoAttachments.isEmpty{
		  VStack{
			 Image(systemName: "photo")
				.font(.title2)
			 Text("No photos attached")
				.font(.headline)
		  }
		  .frame(maxWidth: .infinity, maxHeight: .infinity)
		  .foregroundStyle(theme.primaryDark)
		  .aspectRatio(4, contentMode: .fit)
		  .card(5)
		}else{
		  PhotoSelectionGrid
		}
	 }
	 .animation(.easeInOut, value: photos)
	 .animation(.easeInOut, value: photoAttachments)
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
  @Previewable @State var testPhotos = PhotoAttachment.example()
  PhotoSelection(photos: .constant([]), photoAttachments: $testPhotos, creation: false)
	 .environment(\.theme, .basic)
}


extension PhotoSelection{
  @ViewBuilder
  private var PhotoSelectionGrid: some View{
	 ScrollView{
		LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 10){
		  if creation{
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
		  }
		  if !photos.isEmpty{
			 ForEach(photos, id: \.self) { photo in
				Image(uiImage: photo)
				  .resizable()
				  .containerRelativeFrame(.horizontal, count: 3, spacing: 25)
				  .aspectRatio(1, contentMode: .fill)
				  .clipShape(.rect(cornerRadius: 15))
				  .border(0)
				  .overlay(alignment: .topTrailing){
					 Button{
						photos.removeAll(where: {$0 == photo})
					 }label:{
						Image(systemName: "minus.circle.fill")
						  .font(.title)
						  .foregroundStyle(theme.primary)
					 }
				  }
				  .onTapGesture {
					 withAnimation{
						NavigationManager.shared.addPopUp(.photo(photoKF: nil, photoUI: photo))
					 }
				  }
			 }
		  }else{
			 ForEach(photoAttachments, id: \.id){ photo in
				if let stringUrl = photo.remoteUrl{
				  KFImage(URL(string: stringUrl)!)
					 .placeholder({ _ in
						placeHolder
					 })
					 .resizable()
					 .containerRelativeFrame(.horizontal, count: 3, spacing: 25)
					 .aspectRatio(1, contentMode: .fill)
					 .clipShape(.rect(cornerRadius: 15))
					 .border(0)
					 .overlay(alignment: .topTrailing){
						Button{
						  photoAttachments.removeAll(where: {$0.id == photo.id})
						}label:{
						  Image(systemName: "minus.circle.fill")
							 .font(.title)
							 .foregroundStyle(theme.primary)
						}
						.opacity(creation ? 1 : 0)
						.disabled(!creation)
					 }
					 .onTapGesture {
						withAnimation{
						  NavigationManager.shared.addPopUp(.photo(photoKF: stringUrl, photoUI: nil))
						}
					 }
				}
			 }
		  }
		}
		.padding(1)
	 }
	 .aspectRatio(1.5, contentMode: .fit)
	 .card(5)
  }
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
  
  var placeHolder: some View{
	 Image(systemName: "photo")
		.font(.largeTitle)
		.foregroundStyle(theme.primaryDark)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.aspectRatio(1, contentMode: .fit)
		.card(15)
  }
}


