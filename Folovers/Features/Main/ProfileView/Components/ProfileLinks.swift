//
//  ProfileLinks.swift
//  Folovers
//
//  Created by user on 17.08.2026.
//

import SwiftUI
import AuthLibrary

enum ProfileLinksEnum: String, Identifiable, CaseIterable{
  case notification, appearence, privacy, logout, mail, account, password, todo
  
  var id: String {
	 self.rawValue
  }
  
  var title: String{
	 switch self {
	 case .logout:
		"Log Out"
	 case .password:
		"Resset password"
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
	 case .mail:
		"envelope"
	 case .account:
		"person"
	 case .password:
		"lock"
	 case .todo:
		"checklist"
	 }
  }
}

struct ProfileLinks: View {
  @Environment(\.theme) var theme
  @State private var appearenceView: Bool = false
  @State private var notificationView: Bool = false
  @State private var accountView: Bool = false
  
  var body: some View {
	 VStack{
		
		AppearenceLinkView()
		Divider()
		NotificationLinksView()
		Divider()
		PrivacyLinksView()
		Divider()
		AccountLinks()
		Divider()
		Button{
		  AuthManager.shared.logOut()
		}label:{
		  LinkRow(.logout)
		}
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



