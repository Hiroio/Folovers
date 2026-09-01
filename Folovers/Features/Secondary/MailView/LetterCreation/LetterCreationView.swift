//
//  LetterCreationView.swift
//  Folovers
//
//  Created by user on 26.08.2026.
//

import SwiftUI

struct LetterCreationView: View {
  @Environment(\.theme) var theme
  @State private var vm: LetterCreationViewModel

  init(uid: String){
	 self._vm = State(wrappedValue: LetterCreationViewModel(uid: uid))
  }

	 var body: some View {
		VStack(spacing: 15){
		  header

		  recipientBar

		  TextField("", text: $vm.title, prompt:
						  Text("Letter title...")
			 .foregroundStyle(theme.secondaryText)
		  )
		  .textFieldModifier()
		  .border()

		  TextField("", text: $vm.body, prompt:
						  Text("Write something...")
			 .foregroundStyle(theme.secondaryText),
					  axis: .vertical
		  )
		  .textFieldModifier()
		  .lineLimit(5...10)
		  .border()

		  Button{
			 vm.send()
			 vm.close()
		  }label:{
			 Text("Send")
				.frame(maxWidth: .infinity)
				.border(15)
				.contentShape(.rect)
		  }
		  .buttonStyle(CustomAnimationForBtn(light: true))
		  .disabled(!vm.ableToSend)

		  if vm.mailErrors != nil{
			 HStack(spacing: 5){
				Image(systemName: "exclamationmark.circle")
				Text("Could not send the letter")
			 }
			 .font(.caption)
			 .foregroundStyle(.red)
			 .transition(.move(edge: .top).combined(with: .opacity))
		  }
		}
		.animation(.easeInOut, value: vm.mailErrors)
		.padding()
		.foregroundStyle(theme.primaryDark)
		.frame(maxWidth: .infinity)
		.card(15, lineWidth: 4)
		.fontDesign(.monospaced)
		.padding(.horizontal)
    }
}

#Preview {
  ZStack{
	 ThemePalette.basic.background.ignoresSafeArea()
	 LetterCreationView(uid: "")
		.environment(\.theme, .basic)
  }
}


extension LetterCreationView{
  private var header: some View{
	 Text("Letter")
		.font(.title2.weight(.semibold))
		.frame(maxWidth: .infinity)
		.overlay(alignment: .leading){
		  Button{
			 vm.close()
		  }label:{
			 Image(systemName: "xmark")
				.font(.headline.weight(.semibold))
		  }
		}
  }

  private var recipientBar: some View{
	 HStack{
		Text("To:")
		  .font(.subheadline.weight(.bold))

		SpriteView(action: .preview, config: vm.recipient.characterConfig, size: CGSize(width: 35, height: 35))

		Text(vm.recipient.displayName)
		  .font(.subheadline)
		  .foregroundStyle(vm.isKnown ? theme.primaryDark : theme.secondaryText)

		Spacer()
	 }
	 .border(10)
  }
}
