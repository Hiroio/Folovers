//
//  ProfileLinks.swift
//  Folovers
//
//  Created by user on 17.08.2026.
//

import SwiftUI

enum ProfileLinksEnum: String, Identifiable, CaseIterable{
  case notification, appearence, privacy, logout
  
  var id: String {
	 self.rawValue
  }
  
  var title: String{
	 switch self {
	 case .logout:
		"Log Out"
	 default:
		self.rawValue.capitalized
	 }
  }
  
  var icon: String{
	 switch self {
	 case .notification:
		"bell"
	 case .appearence:
		"paintbrush"
	 case .privacy:
		"lock"
	 case .logout:
		"rectangle.righthalf.inset.fill.arrow.right"
	 }
  }
}

struct ProfileLinks: View {
  @Environment(\.theme) var theme
  @State private var appearenceView: Bool = false
    var body: some View {
		VStack{
			 
		  Button{}label: {
			 HStack{
				LinkRow(.notification)
				Image(systemName: "chevron.right")
				  .foregroundStyle(theme.secondaryText)
			 }
		  }
		  
		  Divider()
		  VStack{
			 Button{
				withAnimation(){
				  appearenceView.toggle()
				}
			 }label: {
				HStack{
				  LinkRow(.appearence)
				  Image(systemName: "chevron.down")
					 .foregroundStyle(theme.secondaryText)
					 .rotationEffect(.degrees(appearenceView ? 180 : 0))
				}
			 }
			 if appearenceView{
				themeSelection
			 }
		  }
		  Divider()
		  LinkRow(.privacy)
		  Divider()
		  LinkRow(.logout)
		}
		.foregroundStyle(theme.primary)
		.fontDesign(.monospaced)
    }
}

#Preview {
    ProfileLinks()
	 .environment(\.theme, .basic)
}


extension ProfileLinks{
  func LinkRow(_ link: ProfileLinksEnum) -> some View{
	 HStack{
		Image(systemName: link.icon)
		Text(link.title)
		Spacer()
	 }
	 .font(.headline)
	 .padding(15)
  }
  
  @ViewBuilder
  private var themeSelection: some View{
	 ScrollView(.horizontal, showsIndicators: false){
		HStack(spacing: 15){
		  ForEach(AppThemeColor.allCases, id: \.rawValue){ themeItem in
			 Button{ withAnimation{ThemeManager.shared.selectedColor = themeItem }}label: {
				ZStack{
				  Circle()
					 .fill(themeItem.palette.primary)
					 .opacity(0.8)
				  if themeItem.palette.primary == theme.primary{
					 Circle()
						.stroke(theme.primaryDark, lineWidth: 3)
				  }
				}
				.frame(width: 45, height: 45)
				.padding(3)
			 }
		  }
		}
		.padding(.horizontal)
	 }
  }
}



