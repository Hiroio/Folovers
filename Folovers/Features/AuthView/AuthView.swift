//
//  AuthView.swift
//  Folovers
//
//  Created by user on 12.08.2026.
//

import SwiftUI
import AuthLibrary

struct AuthView: View {
  @State private var vm: AuthViewModel = .init()
  var body: some View {
	 VStack(spacing: 15){
		
		Spacer()
		Image(systemName: "heart.fill")
		  .font(.largeTitle)
		  .foregroundStyle(.red)
		  .padding(.bottom, 40)
		
		Group{
		  TextField("", text: $vm.email, prompt:
						  Text("Email")
			 .foregroundStyle(.red.opacity(0.4))
		  )
		  .textContentType(.emailAddress)
		  
		  PasswordField(password: $vm.password)
		}
		.foregroundStyle(.red.opacity(0.4))
		.frame(maxWidth: .infinity)
		.padding()
		.background(
		  RoundedRectangle(cornerRadius: 15)
			 .fill(.gray.opacity(0.2))
		)
		.fontDesign(.monospaced)
		
		
		Button{
		  
		}label: {
		  Text("Continue")
			 .foregroundStyle(.red)
			 .fontDesign(.monospaced)
			 .frame(maxWidth: .infinity)
			 .padding()
			 .background(
				RoundedRectangle(cornerRadius: 15)
				  .stroke(.red, lineWidth: 2)
			 )
		}
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
