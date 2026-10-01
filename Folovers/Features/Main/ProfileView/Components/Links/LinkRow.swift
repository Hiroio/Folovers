//
//  LinkRow.swift
//  Folovers
//
//  Created by user on 01.10.2026.
//

import SwiftUI

struct LinkRow: View {
  let link: ProfileLinksEnum
  init(_ link: ProfileLinksEnum){
	 self.link = link
  }
  var body: some View {
	 HStack{
		Image(systemName: link.icon)
		Text(link.title)
		Spacer()
	 }
	 .font(.headline)
	 .padding(15)
  }
}

#Preview {
  LinkRow(.account)
}
