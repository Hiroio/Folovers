//
//  PlansView.swift
//  Folovers
//
//  Created by user on 29.08.2026.
//

import SwiftUI

struct PlansView: View {
  @Namespace var nm
  @Environment(\.theme) var theme
  @State private var vm: PlansViewModel
  init(folder: FolderModel){
	 self._vm = State(wrappedValue: PlansViewModel(folder: folder))
  }
  var body: some View {
	 ZStack{
		VStack{
		  Header
			 .zIndex(10)
		  
		  VStack(alignment: .leading, spacing: 0){
			 ZStack(alignment: .bottom){
				ForEach(PlanType.allCases) {type in
				  let active = vm.plansState == type
				  Button{
					 withAnimation(.easeInOut(duration: 0.3)){
						vm.plansState = type
					 }
				  }label: {
					 TabHeader(title: type.title)
						.foregroundStyle(theme.primaryDark)
						.opacity(active ? 1 : 0.7)
						.scaleEffect(active ? 1.1 : 0.9)
				  }
				  .compositingGroup()
				  .shadow(color: .black.opacity(0.25), radius: 3, x: 3, y: -4)
				  .frame(maxWidth: .infinity, alignment: type.alignment)
				}
			 }
			 .zIndex(1)
			 Group{
				switch vm.plansState {
				case .plans:
				  PlansGridView(vm: vm, plans: PlanCard.plans())
					 .transition(.asymmetric(insertion: .scale(scale: 0.7, anchor: .topLeading).combined(with: .opacity), removal: .opacity))
				case .memories:
				  PlansGridView(vm: vm, plans: PlanCard.plans())
					 .transition(.asymmetric(insertion: .scale(scale: 0.7, anchor: .topTrailing).combined(with: .opacity), removal: .opacity))
				  
				}
			 }
			 .background(
				vm.folder.folderColor.palette.background
			 )
			 .shadow(color: .black.opacity(0.05), radius: 0, y: -1)
			 
		  }
		  .zIndex(-2)
		  .compositingGroup()
		}
		.overlay(alignment: .bottom){
			 Button{}label:{
				Text("Delete: \(vm.selected.count)")
				  .frame(maxWidth: .infinity)
				  .border(15, dashed: true, color: vm.folder.folderColor.palette.primary)
				  .foregroundStyle(vm.folder.folderColor.palette.primary)
				  .padding(.horizontal, 20)
				  .contentShape(.rect)
			 }
			 .buttonStyle(CustomAnimationForBtn(light: false))
			 .scaleEffect(vm.editingState ? 1 : 0,anchor: .bottom)
		}
		
		
		
		Color.black.opacity(0.0000001)
		  .zIndex(-1)
		  .onTapGesture {
			 withAnimation {
				vm.showMenu = false
			 }
		  }
		  .allowsHitTesting(vm.showMenu)
	 }
	 .fullScreenCover(isPresented: $vm.creationState) {
		ZStack{
		  theme.background.ignoresSafeArea()
		  PlanCreationView(folderId: vm.folderId, planState: vm.creationType){
			 vm.fetchAllPlans()
		  }
		  .ignoresSafeArea(edges: .bottom)
		}
	 }
	 .fontDesign(.monospaced)
  }
}

#Preview {
  ZStack{
	 ThemePalette.basic.background.ignoresSafeArea()
	 PlansView(folder: .personal)
		.environment(\.theme, .basic)
  }
}

extension PlansView{
  private var Header: some View{
	 HStack{
		Button{
		  withAnimation{
			 NavigationManager.shared.popSecondary()
		  }
		}label:{
		  Image(systemName: "chevron.left")
			 .font(.title3)
			 .foregroundStyle(theme.text)
		}
		Text(vm.folder.title)
		  .font(.title2)
		  .frame(maxWidth: .infinity, alignment: .leading)
		
		
		HStack{
		  ForEach(PlanGridViewEnum.allCases, id: \.self){item in
			 let active = item == vm.gridView
			 Button{
				withAnimation {
				  vm.gridView = item
				}
			 }label:{
				Image(systemName: "\(item.icon)\(active ? ".fill" : "")")
				  .foregroundStyle(active ? theme.primary : theme.secondaryText)
				  .padding(10)
			 }
		  }
		}
		.border(color: theme.secondaryText)
		
		if vm.editingState{
		  Button{
			 withAnimation{
				vm.editingState = false
			 }
		  }label:{
			 Image(systemName: "pencil")
				.card(10)
				.font(.footnote)
				.foregroundStyle(theme.primaryDark)
				.padding(3)
				.overlay(alignment: .topTrailing){
				  Image(systemName: "xmark")
					 .font(.caption.weight(.bold))
					 .foregroundStyle(theme.text)
				}
		  }
		}else{
		  Button{
			 withAnimation{
				vm.showMenu = true
			 }
		  }label:{
			 Image(systemName: "ellipsis")
				.foregroundStyle(theme.text)
				.border(15, color: theme.secondaryText)
		  }
		  .overlay(alignment: .topTrailing){
			 MenuSection
				.fixedSize()
				.zIndex(2)
				.scaleEffect(vm.showMenu ? 1.1 : 0, anchor: .topTrailing)
				.allowsHitTesting(vm.showMenu)
		}
		}
	 }
	 .padding()
  }
  
  
  
  private func TabHeader(title: String) -> some View{
	 Text(title)
		.fontWeight(.bold)
		.frame(width: 100, alignment: .leading)
		.padding(10)
		.padding(.horizontal)
		.background(
		  TabShape()
			 .fill(vm.folder.folderColor.palette.background)
		)
  }
  
  
  private var MenuSection: some View{
	 VStack(alignment: .leading, spacing: 15){
		Button{
		  withAnimation{
			 vm.showMenu = false
			 vm.editingState = true
		  }
		}label:{
		  HStack{
			 Text("Edit Plans")
			Image(systemName: "pencil")
		  }
		}
		
		Divider()
		
		Button{
		  
		}label:{
		  HStack{
			 Text("Delete Folder")
			 Image(systemName: "trash")
		  }
		}
	 }
	 .card(10, palette: vm.folder.folderColor.palette)
	 .font(.footnote)
	 .foregroundStyle(vm.folder.folderColor.palette.primaryDark)
	 .zIndex(1)
  }
}
