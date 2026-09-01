//
//  LetterItemGrid.swift
//  Folovers
//
//  Created by user on 26.08.2026.
//

import SwiftUI

struct LetterItemGrid: View {
  @Environment(\.theme) var theme
  let letter: MailModel
  let user: UserDocument
  var incoming: Bool = true

	 var body: some View {
		HStack(spacing: 10){
		  SpriteView(action: .preview, config: user.characterConfig, size: CGSize(width: 42, height: 42))
			 .border(5)

		  VStack(alignment: .leading, spacing: 2){
			 HStack(spacing: 4){
				Text(incoming ? "From:" : "To:")
				  .font(.caption2)
				  .foregroundStyle(theme.secondaryText)

				Text(user.displayName)
				  .font(.footnote.bold())
				  .foregroundStyle(theme.primary)
			 }

			 Text(letter.title)
				.font(.headline.weight(isUnread ? .bold : .regular))
				.lineLimit(1)
		  }
		  .frame(maxWidth: .infinity, alignment: .leading)

		  VStack(alignment: .trailing, spacing: 6){
			 Text(formattedDate)
				.font(.footnote)
				.foregroundStyle(theme.secondaryText)

			 if isUnread{
				Circle()
				  .fill(theme.primary)
				  .frame(width: 8, height: 8)
			 }
		  }
		}
		.foregroundStyle(theme.primaryDark)
		.card(10)
    }

  var isUnread: Bool{
	 incoming && letter.status != .seen
  }

  var formattedDate: String{
	 if Calendar.current.isDate(letter.createdAt, inSameDayAs: .now){
		letter.createdAt.formatted(.dateTime.hour().minute())
	 }else{
		letter.createdAt.formatted(.dateTime.day().month())
	 }
  }
}

#Preview {
  ZStack{
	 ThemePalette.basic.background.ignoresSafeArea()
	 VStack{
		LetterItemGrid(
		  letter: MailModel(id: "", title: "The preview Letter", body: "qweqweqweqw", status: .sent, createdBy: "", createdFor: "", createdAt: .now),
		  user: .unknown(id: "qwe")
		)
		LetterItemGrid(
		  letter: MailModel(id: "2", title: "Already seen one", body: "qweqweqweqw", status: .seen, createdBy: "", createdFor: "", createdAt: .distantPast),
		  user: .placeholder(id: "abcd"),
		  incoming: false
		)
	 }
	 .padding()
	 .environment(\.theme, .basic)
	 .fontDesign(.monospaced)
  }
}
