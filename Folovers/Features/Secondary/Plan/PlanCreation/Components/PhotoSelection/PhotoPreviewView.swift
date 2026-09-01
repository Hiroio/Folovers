//
//  PhotoPreviewView.swift
//  Folovers
//
//  Created by user on 25.08.2026.
//

import SwiftUI
import Kingfisher

struct PhotoPreviewView: View {
  @Environment(\.theme) var theme
  let photo: UIImage?
  let photoURL: String?
  
  init(photo: UIImage?, photoURL: String?) {
	 self.photo = photo
	 self.photoURL = photoURL
  }
    var body: some View {
		VStack{
		  Text("Preview")
			 .font(.title2.weight(.semibold))
		  photoView
			 .clipShape(.rect(cornerRadius: 15))
			 .border()
			 .padding()
			 .scaledToFit()
		  
		  Button{
			 withAnimation {
				NavigationManager.shared.popPopUp()
			 }
		  }label:{
			 Text("Close")
				.font(.headline.weight(.semibold))
				.border(10, lineWidth: 2)
		  }
		}
		.card(10)
		.fontDesign(.monospaced)
		.foregroundStyle(theme.primaryDark)
		.padding(20)
    }
}

#Preview {
    PhotoPreviewView(photo: nil, photoURL: "https://picsum.photos/200/300")
}



extension PhotoPreviewView{
  @ViewBuilder
  private var photoView: some View{
	 if let photo {
		Image(uiImage: photo)
		  .resizable()
	 }else if let url = photoURL{
		KFImage(URL(string: url))
		  .resizable()
	 }
  }
}
