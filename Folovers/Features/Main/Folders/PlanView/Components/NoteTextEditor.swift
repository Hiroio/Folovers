//
//  NoteTextEditor.swift
//  Folovers
//
//  Created by user on 15.08.2026.
//

import SwiftUI

struct NoteTextEditor: View {
  @Environment(\.theme) var theme
  init(){
	 UITextView.appearance().backgroundColor = .clear
  }
  @State private var noteText: String = ""
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
			 .font(.footnote)
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
	 NoteTextEditor()
		.environment(\.theme, .basic)
		.foregroundStyle(ThemePalette.basic.primary)
  }
}
