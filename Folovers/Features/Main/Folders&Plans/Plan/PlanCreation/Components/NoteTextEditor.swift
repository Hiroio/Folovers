//
//  NoteTextEditor.swift
//  Folovers
//
//  Created by user on 15.08.2026.
//

import SwiftUI

struct NoteTextEditor: View {
  @Environment(\.theme) var theme
  init(noteText: Binding<String>){
	 UITextView.appearance().backgroundColor = .clear
	 self._noteText = noteText
  }
  @Binding var noteText: String
    var body: some View {
		VStack{
		  HStack{
			 Text("Note")
				.frame(maxWidth: .infinity, alignment: .leading)
			 
			 Image(systemName: "note.text")
		  }
		  .font(.headline.weight(.bold))
		  .padding(5)
		  TextEditor(text: $noteText)
			 .scrollContentBackground(.hidden)
			 .font(.subheadline.weight(.bold))
			 .lineSpacing(5)
			 .foregroundStyle(theme.primaryDark)
			 .padding(5)
		}
		  .padding(5)
		  .background(
			 NoteBorder()
				.fill(theme.background)
		  )
		  .overlay {
			 NoteBorder()
				.stroke(theme.primaryDark, style: .init(lineWidth: 2, lineCap: .round, lineJoin: .round))
		  }
		  .fontDesign(.monospaced)
    }
}

#Preview {
  ZStack{
	 ThemePalette.basic.background.ignoresSafeArea()
	 ThemePalette.basic.surface.ignoresSafeArea()
	 NoteTextEditor(noteText: .constant("QWeqwe qwe qwe qwe wqe qw"))
		.environment(\.theme, .basic)
		.foregroundStyle(ThemePalette.basic.primary)
  }
}
