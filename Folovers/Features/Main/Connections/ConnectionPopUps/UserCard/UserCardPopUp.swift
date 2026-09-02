//
//  UserCardPopUp.swift
//  Folovers
//
//  Created by user on 22.08.2026.
//

import SwiftUI

struct UserCardPopUp: View {
  @Environment(\.theme) var theme
  @State private var vm: UserCardViewModel

  init(uid: String, user: UserDocument?){
	 self._vm = State(wrappedValue: UserCardViewModel(uid: uid, user: user))
  }

	 var body: some View {
		VStack{
		  UserSegmentedPicker(state: $vm.popUpState)
			 
		  ZStack{
			 VStack(spacing: 15){
				Header
				if vm.popUpState == .user{
				  UserCardView(vm: vm)
					 .zIndex(-1)
					 .transition(.blurReplace)
				}else{
				  UserTodoList(todos: vm.userTodos)
					 .zIndex(-1)
					 .transition(.blurReplace)
				}
			 }
			 Color.black.opacity(0.0001)
				.scaledToFit()
				.onTapGesture {
				  vm.menuIsActive = false
				}
				.zIndex(-1)
				.allowsHitTesting(vm.menuIsActive)
		  }
		  .frame(maxWidth: .infinity, maxHeight: .infinity)
		  .aspectRatio(0.8, contentMode: .fit)
		  .card(15, lineWidth: 5, dashed: true)
		  .padding()
		  .task{
			 await vm.loadUser()
		  }
		}
		.fontDesign(.monospaced)
    }
}

#Preview {
  UserCardPopUp(uid: "qwerqwe", user: nil)
	 .environment(\.theme, .basic)
}


extension UserCardPopUp{
  private var Header: some View{
	 HStack{
		Button{
		  NavigationManager.shared.popPopUp()
		}label: {
		  Image(systemName: "xmark")
			 .foregroundStyle(theme.primaryDark)
			 .padding(5)
		}
		Spacer()
		
		Button{
		  withAnimation{
			 vm.menuIsActive = true
		  }
		}label:{
		  Image(systemName: "ellipsis")
			 .foregroundStyle(theme.primaryDark)
		}
		.overlay(alignment: .topTrailing){
		  MenuSection
			 .fixedSize()
			 .zIndex(2)
			 .scaleEffect(vm.menuIsActive ? 1.1 : 0, anchor: .topTrailing)
			 .allowsHitTesting(vm.menuIsActive)
		}
		.opacity(vm.btnStatus == .connected ? 1 : 0)
	 }
	 .font(.title2)
	 .frame(maxWidth: .infinity, alignment: .trailing)
  }
  
  
  private var MenuSection: some View{
	 VStack(alignment: .leading, spacing: 15){
		Button{
		  withAnimation{
			 vm.goToFolder()
		  }
		}label:{
		  HStack{
			 Text("Go to Folder")
			 Image(systemName: "folder")
		  }
		}
		.disabled(vm.sharedFolder == nil)
		.opacity(vm.sharedFolder == nil ? 0.4 : 1)
		
		Divider()
		
		Button{
		  withAnimation{
			 vm.createFolder()
		  }
		}label:{
		  HStack{
			 Text("Create Folder")
			Image(systemName: "plus.app")
		  }
		}
		.disabled(vm.sharedFolder != nil)
		.opacity(vm.sharedFolder != nil ? 0.4 : 1)
		
		Divider()
		
		Button{
		  vm.deleteConnection()
		}label:{
		  HStack{
			 Text("Remove")
			 Image(systemName: "trash")
		  }
		}
	 }
	 .card(10)
	 .font(.footnote)
	 .foregroundStyle(theme.primaryDark)
	 .zIndex(1)
  }
}
