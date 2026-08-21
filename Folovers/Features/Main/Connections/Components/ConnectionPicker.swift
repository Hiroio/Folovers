//
//  ConnectionPicker.swift
//  Folovers
//
//  Created by user on 21.08.2026.
//

import SwiftUI

struct ConnectionPicker: View {
  @Namespace var nameSpace
  @Environment(\.theme) var theme
  @Binding var status: ConnectionStatus
    var body: some View {
		HStack{
		  ForEach(ConnectionStatus.allCases, id: \.self){item in
			 let active = status == item
			 Button{
				withAnimation{
				  status = item
				}
			 }label:{
				  Text(item.title)
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
						.matchedGeometryEffect(id: "Connection", in: nameSpace)
						.padding(.horizontal)
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
  @Previewable @State var status: ConnectionStatus = .accepted
  ZStack{
	 ThemePalette.basic.background.ignoresSafeArea()
	 ConnectionPicker(status: $status)
		.environment(\.theme, .basic)
  }
  .fontDesign(.monospaced)
}
