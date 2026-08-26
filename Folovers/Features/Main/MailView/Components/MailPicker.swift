//
//  MailPicker.swift
//  Folovers
//
//  Created by user on 26.08.2026.
//

import SwiftUI

struct MailPicker: View {
  @Namespace var nameSpace
  @Environment(\.theme) var theme
  @Binding var state: MailType
  var unreadCount: Int = 0

	 var body: some View {
		HStack{
		  ForEach(MailType.allCases){item in
			 let active = state == item
			 Button{
				withAnimation{
				  state = item
				}
			 }label:{
				HStack(spacing: 6){
				  Image(systemName: item.icon)

				  Text(item.title)

				  if item == .received && unreadCount > 0{
					 Text("\(unreadCount)")
						.font(.caption2.weight(.bold))
						.foregroundStyle(theme.surface)
						.padding(.horizontal, 6)
						.padding(.vertical, 2)
						.background(Capsule().fill(theme.primary))
				  }
				}
				.font(.subheadline.weight(active ? .bold : .regular))
				.foregroundStyle(active ? theme.primary : theme.secondaryText)
				.frame(maxWidth: .infinity)
				.padding(.vertical, 10)
			 }
			 .buttonStyle(CustomAnimationForBtn(light: true))
			 .background(
				Group{
				  if active{
					 RoundedRectangle(cornerRadius: 15)
						.fill(.white.opacity(0.6))
						.matchedGeometryEffect(id: "MailPicker", in: nameSpace)
						.padding(.horizontal, 5)
				  }
				}
			 )
			 .padding(5)
		  }
		}
		.background(
		  RoundedRectangle(cornerRadius: 15)
			 .fill(theme.primary.opacity(0.1))
		)
    }
}

#Preview {
  @Previewable @State var state: MailType = .received
  ZStack{
	 ThemePalette.basic.background.ignoresSafeArea()
	 MailPicker(state: $state, unreadCount: 3)
		.environment(\.theme, .basic)
		.padding()
  }
  .fontDesign(.monospaced)
}


enum MailType: String, Identifiable, CaseIterable{
  case received, sent

  var id: String{
	 self.rawValue
  }

  var title: String{
	 self.rawValue.capitalized
  }

  var icon: String{
	 switch self {
	 case .received:
		"tray.and.arrow.down"
	 case .sent:
		"paperplane"
	 }
  }

  var transition: AnyTransition{
	 switch self {
	 case .received:
		  .move(edge: .leading).combined(with: .opacity)
	 case .sent:
		  .move(edge: .trailing).combined(with: .opacity)
	 }
  }

  var emptyText: String{
	 switch self {
	 case .received:
		"No letters yet"
	 case .sent:
		"Nothing sent yet"
	 }
  }
}
