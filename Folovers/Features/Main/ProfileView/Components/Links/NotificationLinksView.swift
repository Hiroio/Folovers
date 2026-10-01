//
//  NotificationLinksView.swift
//  Folovers
//
//  Created by user on 01.10.2026.
//

import SwiftUI

struct NotificationLinksView: View {
  @Environment(\.theme) var theme
  @State private var notificationExpanded: Bool = false
  @AppStorage("mailNotificationsEnabled") private var mailNotification: Bool = false
  @State private var pushManager = PushNotificationManager.shared
    var body: some View {
		VStack{
		  Button{
			 withAnimation(){
				notificationExpanded.toggle()
			 }
		  }label: {
			 HStack{
				LinkRow(.notification)
				Image(systemName: "chevron.right")
				  .foregroundStyle(theme.secondaryText)
				  .rotationEffect(Angle(degrees: notificationExpanded ? 90 : 0))
			 }
			 .contentShape(.rect)
		  }
		  
		  if notificationExpanded{
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
		.onChange(of: pushManager.isAuthorized){ _, isAuthorized in
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
    NotificationLinksView()
	 .environment(\.theme, .basic)
}
