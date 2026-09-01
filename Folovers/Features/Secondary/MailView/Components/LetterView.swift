//
//  LetterView.swift
//  Folovers
//
//  Created by user on 26.08.2026.
//

import SwiftUI

struct LetterView: View {
  @Environment(\.theme) var theme
  let letter: MailModel
    var body: some View {
		VStack(alignment: .center, spacing: 15){
		  
		  Button{
			 NavigationManager.shared.popPopUp()
		  }label: {
			 Image(systemName: "xmark")
				.font(.headline)
				.foregroundStyle(theme.primaryDark)
		  }
		  .frame(maxWidth: .infinity, alignment: .trailing)
		  
		  VStack(spacing: 15){
			 Text(letter.title)
				.font(.title2.weight(.medium))
				.foregroundStyle(theme.primaryDark)
			 
			 ScrollView{
				Text(letter.body)
				  .fontWeight(.medium)
				  .kerning(1.2)
				  .lineSpacing(12)
				  .multilineTextAlignment(.leading)
				  .padding()
			 }
			 .frame(maxWidth: .infinity, alignment: .center)
			 .aspectRatio(1, contentMode: .fit)
			 .defaultScrollAnchor(.center)
			 .card()
		  }
		  
		  HStack{
			 Text(isIncoming ? "From:" : "To:")
				.font(.subheadline.weight(.semibold))
				.foregroundStyle(theme.secondaryText)

			 SpriteView(action: .preview, config: counterpart.characterConfig, size: CGSize(width: 30, height: 30))

			 Text(counterpart.displayName)
				.font(.headline.weight(.bold))
		  }
		  .frame(maxWidth: .infinity, alignment: .leading)
		  
		  
		  
		  HStack(spacing: 10){
			 if isIncoming{
				Button{
				  NavigationManager.shared.addPopUp(.letterCreation(to: letter.createdBy))
				}label:{
				  Text("Reply")
				  Image(systemName: "arrowshape.turn.up.left")
				}
				.font(.headline)
				.foregroundStyle(theme.secondaryText)
				.border(10, color: theme.secondaryText)
			 }
			 Divider().fixedSize()
			 
			 Button{
				MailManager.shared.deleteMail(mail: letter)
				NavigationManager.shared.popPopUp()
			 }label: {
				Text("Delete")
				Image(systemName: "trash")
			 }
			 .font(.headline)
			 .foregroundStyle(theme.primary)
			 .border(10)
		  }
		  .frame(maxWidth: .infinity, alignment: .trailing)
		}
		.card(15)
		.fontDesign(.monospaced)
		.padding()
    }
}

extension LetterView{
  var isIncoming: Bool{
	 letter.createdBy != AuthManager.shared.id
  }

//  Not a connection means the sender stays "Unknown User"
  var counterpart: UserDocument{
	 ConnectionManager.knownUser(for: isIncoming ? letter.createdBy : letter.createdFor)
  }
}

#Preview {
  ZStack{
	 ThemePalette.basic.background.ignoresSafeArea()
	 LetterView(letter: MailModel(id: "", title: "The preview Letter", body: "Some words in here", status: .sent, createdBy: "someone", createdFor: "", createdAt: .now))
		.environment(\.theme, .basic)
  }
}
