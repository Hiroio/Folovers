//
//  SimilarTodosList.swift
//  Folovers
//
//  Created by user on 02.09.2026.
//

import SwiftUI

struct SimilarTodosList: View {
  let todos: [TodoItem]
  let palette: ThemePalette
  let onSelect: (TodoItem) -> ()

  @State private var rowHeight: CGFloat = 0

  private let visibleRows = 3
  private let spacing: CGFloat = 5

//  Three rows tall, whatever a row turns out to be. Measured instead of guessed,
//  so it stays right if the font or the row layout changes
  private var listHeight: CGFloat? {
	 guard rowHeight > 0 else { return nil }

	 let rows = min(todos.count, visibleRows)
	 return CGFloat(rows) * rowHeight + CGFloat(max(rows - 1, 0)) * spacing
  }

	 var body: some View {
		ScrollView{
		  LazyVStack(spacing: spacing){
			 ForEach(todos){item in
				Button{
				  onSelect(item)
				}label:{
				  VStack(alignment: .leading){
					 Text(item.title)
						.font(.footnote.weight(.semibold))
						.foregroundStyle(palette.primary)
						.lineLimit(1)

					 Text(item.note ?? "")
						.font(.caption2.weight(.medium))
						.foregroundStyle(palette.secondaryText)
						.lineLimit(1)
				  }
				  .padding(10)
				  .frame(maxWidth: .infinity, alignment: .leading)
				}
				.onGeometryChange(for: CGFloat.self){ proxy in
				  proxy.size.height
				} action: { height in
				  if height > 0 { rowHeight = height }
				}
			 }
		  }
		  .padding(1)
		}
		.frame(maxWidth: .infinity)
		.frame(height: listHeight)
//		No bouncing while everything already fits
		.scrollBounceBehavior(.basedOnSize)
		.padding(5)
		.padding(.top)
		.background(
		  RoundedRectangle(cornerRadius: 10)
			 .fill(palette.surface)
		)
    }
}

#Preview {
  SimilarTodosList(todos: [], palette: .basic){item in}
}
