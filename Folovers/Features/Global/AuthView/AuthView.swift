//
//  AuthView.swift
//  Folovers
//
//  Created by user on 12.08.2026.
//

import SwiftUI
import AuthLibrary

struct AuthView: View {
  @Environment(\.theme) var theme
  @State private var vm: AuthViewModel = .init()
  var body: some View {
	 VStack(spacing: 15){
		
		Spacer()
		Button{
		  let themeColor: AppThemeColor = ThemeManager.shared.selectedColor == .red ? .blue : .red
		  withAnimation(.easeInOut(duration: 0.5)){
			 ThemeManager.shared.selectedColor = themeColor
		  }
		}label: {
		  Image(systemName: "heart")
			 .font(.largeTitle)
			 .foregroundStyle(theme.primary)
			 .padding(.bottom, 40)
		}
		Group{
		  TextField("", text: $vm.email, prompt:
						  Text("Email")
			 .foregroundStyle(theme.primary.opacity(0.4))
		  )
		  .textContentType(.emailAddress)
		  
		  PasswordField(password: $vm.password, primaryColor: theme.primary)
		}
		.textFieldModifier()
		
		
		Button{
		  ThemeManager.shared.selectedColor = .blue
		}label: {
		  Text("Continue")
			 .frame(maxWidth: .infinity)
		}
		.buttonStyle(ButtonStyleBorder())
		.disabled(!vm.isValid)
		.opacity(vm.isValid ? 1 : 0.5)
		
		Spacer()
		SSOView
	 }
	 .padding()
  }
}

#Preview {
//  @Previewable @Namespace var previewNM
  AuthView()
}


extension AuthView{
  private var SSOView: some View{
	 VStack(spacing: 10){
		AppleSignBtn(action: AuthManager.shared.continueWithSSO)
		
		GoogleSignBtn(action: AuthManager.shared.continueWithSSO)
	 }
  }
}
