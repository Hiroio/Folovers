//
//  CharacterAppearanceView.swift
//  Folovers
//
//  Created by user on 14.08.2026.
//

import SwiftUI
import SpritePackage

struct CharacterAppearanceView: View {
  @Environment(\.dismiss) var dismiss
  @Environment(\.theme) var theme
  @State private var vm: CharacterCreationViewModel
  init(user: UserDocument? = nil){
	 self._vm = State(initialValue: CharacterCreationViewModel(user: user))
  }
  
  var body: some View {
	 VStack{
		
		VStack(spacing: 20){
		  if !vm.isEditing{
			 genderSelection
		  }
		  
		  SpriteView(action: .idle, controller: vm.characterController)
			 .frame(maxWidth: .infinity)
		  
		  ScrollView{
			 if vm.nameIsGiven{
				VStack{
				  Text("Give me a name")
					 .font(.title2.weight(.semibold))
				  
				  TextField("", text: $vm.characterName, prompt: Text("Your Name"))
					 .textFieldModifier()
				}
				.foregroundStyle(theme.primary)
			 }else{
				HStack{
				  Text("My name is:")
					 .font(.title3.weight(.semibold))
				  
				  TextField("", text: $vm.characterName, prompt: Text("Your Name"))
					 .textFieldModifier()
				}
			 }
			 
			 ItemsSelection(selectedItem: vm.character.hair, action: vm.changeHairStyle)
			 
			 ItemsSelection(selectedItem: vm.character.top, action: vm.changeTop)
			 
			 ItemsSelection(selectedItem: vm.character.bottom, action: vm.changeBottom)
		  }
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		
		Button{
		  if vm.nameIsGiven{
			 if vm.isEditing{
				Task{
				  if await vm.updateUserDocument() {
					 dismiss()
				  }
				}
			 }else{
				vm.createDocument()
			 }
		  }else{
			 withAnimation(.bouncy(duration: 0.6)){
				vm.nameIsGiven.toggle()
			 }
		  }
		}label: {
		  Text(vm.isEditing ? "Save" : "Continue")
			 .frame(maxWidth: .infinity)
		}
		.buttonStyle(ButtonStyleBorder())
	 }
	 .padding()
	 .fontDesign(.monospaced)
  }
}

#Preview {
  ZStack{
	 ThemePalette.basic.background.ignoresSafeArea()
	 CharacterAppearanceView()
		.environment(\.theme, .basic)
  }
}


extension CharacterAppearanceView{
  
  private var genderSelection: some View{
	 HStack{
		Group{
		  Button{
			 vm.changeGender()
		  }label:{
			 FemaleIcon()
				.stroke(style: .init(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
				.frame(width: 20, height: 20)
				.padding(10)
				.background(
				  RoundedRectangle(cornerRadius: 15)
					 .fill(vm.isMale ? .clear : theme.surface)
				)
				.border(0)
		  }
		  Button{
			 vm.changeGender()
		  }label:{
			 MaleIcon()
				.stroke(style: .init(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
				.frame(width: 20, height: 20)
				.padding(10)
				.background(
				  RoundedRectangle(cornerRadius: 15)
					 .fill(vm.isMale ? theme.surface : .clear)
				)
				.border(0)
		  }
		}
		.foregroundStyle(theme.primary)
	 }
  }
}
