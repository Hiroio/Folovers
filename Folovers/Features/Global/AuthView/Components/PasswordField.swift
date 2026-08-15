//
//  PasswordField.swift
//  Folovers
//
//  Created by user on 12.08.2026.
//

import SwiftUI

struct PasswordField: View {
  @Binding var password: String
  let primaryColor: Color
  @State var showPassword: Bool = false
  @FocusState var focus1: Bool
  @FocusState var focus2: Bool
  var body: some View {
	 HStack{
		ZStack{
		  Group{
			 TextField("Password", text: $password, prompt:
							 Text("Password")
				.foregroundStyle(primaryColor.opacity(0.4))
			 )
				.textContentType(.password)
				.focused($focus1)
				.opacity(showPassword ? 1 : 0)
			 
			 SecureField("", text: $password, prompt:
								Text("Password")
				.foregroundStyle(primaryColor.opacity(0.4))
			 )
				.textContentType(.password)
				.focused($focus2)
				.opacity(showPassword ? 0 : 1)
		  }
		  .frame(maxWidth: .infinity)
		}
		Button{
		  showPassword.toggle()
		  if focus1 || focus2 {
			 showPassword ? focus1.toggle() : focus2.toggle()
		  }
		}label: {
		  Image(systemName: !showPassword ? "eye.slash.fill" : "eye.fill")
			 .font(.headline)
			 .foregroundStyle(primaryColor)
		}
	 }
	 .animation(.easeInOut, value: showPassword)
  }
}

#Preview {
  PasswordField(password: .constant(""), primaryColor: .red)
}
