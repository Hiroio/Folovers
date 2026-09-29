//
//  ProfileLinks.swift
//  Folovers
//
//  Created by user on 17.08.2026.
//

import SwiftUI

enum ProfileLinksEnum: String, Identifiable, CaseIterable{
  case notification, appearence, privacy, logout, mail
  
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
	 case .mail:
		"envelope"
	 }
  }
}

struct ProfileLinks: View {
  @Environment(\.theme) var theme
  @State private var appearenceView: Bool = false
  @State private var notificationView: Bool = false
  @State private var pushManager = PushNotificationManager.shared
  @AppStorage("mailNotificationsEnabled") private var mailNotification: Bool = false
    var body: some View {
		VStack{
			 
		  VStack{
			 Button{
				withAnimation(){
				  notificationView.toggle()
				}
			 }label: {
				HStack{
				  LinkRow(.notification)
				  Image(systemName: "chevron.right")
					 .foregroundStyle(theme.secondaryText)
					 .rotationEffect(Angle(degrees: notificationView ? 90 : 0))
				}
			 }
			 
			 if notificationView{
				HStack{
				  Rectangle()
					 .frame(width: 2)
					 .fixedSize(horizontal: false, vertical: true)
					 .padding(.leading, 5)
				  VStack{
					 HStack{
						LinkRow(.mail)
						CustomToggle(isOn: $mailNotification)
						  .containerRelativeFrame(.horizontal, count: 5, spacing: 10)
					 }
				  }
				  .frame(maxWidth: .infinity, alignment: .leading)
				}
				.padding(.horizontal)
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
				  Image(systemName: "chevron.right")
					 .foregroundStyle(theme.secondaryText)
					 .rotationEffect(.degrees(appearenceView ? 90 : 0))
				}
			 }
			 
			 if appearenceView{
				ColorSelectionBar(color: Binding(get: {
				  ThemeManager.shared.selectedColor
				}, set: { color in
				  withAnimation {
					 ThemeManager.shared.selectedColor = color
				  }
				}))
				.padding(.horizontal)
				.transition(.opacity.combined(with: .scale(0.2, anchor: .topLeading)))
			 }
		  }
		  
		  Divider()
		  LinkRow(.privacy)
		  Divider()
		  Button{
			 AuthManager.shared.logOut()
		  }label:{
			 LinkRow(.logout)
		  }
		}
		.foregroundStyle(theme.primary)
		.fontDesign(.monospaced)
		.onChange(of: pushManager.isAuthorized){ _, isAuthorized in
//		  Saying yes to the system prompt should be enough - no reason to
//		  also make them flip this switch by hand right after
		  if isAuthorized{
			 mailNotification = true
		  }
		}
		.onChange(of: mailNotification){ _, isOn in
		  if isOn{
			 pushManager.syncTokenIfNeeded()
		  }else{
			 pushManager.clearToken()
		  }
		}
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



