//
//  LocationSelectionSheet.swift
//  Folovers
//
//  Created by user on 19.08.2026.
//

import SwiftUI

struct LocationSelectionSheet: View {
  @Environment(\.dismiss) var dismiss
  @Environment(\.theme) var theme
  let onSubmit: (PlanLocation) -> ()
  @State private var vm = LocationSearchViewModel()
  var body: some View {
	 VStack{
		if vm.selected{
		  HStack{
			 
			 Button{
				withAnimation{
				  vm.selected = false
				}
			 }label:{
				Image(systemName: "arrow.left")
				  .border(10)
			 }
			 
			 Spacer()
			 
			 Button{
				if let location = vm.selectedLocation{
				  withAnimation{
					 onSubmit(location)
					 dismiss()
				  }
				}
			 }label:{
				Image(systemName: "checkmark")
				  .border(10)
			 }
		  }
		  .transition(.move(edge: .top))
		  .foregroundStyle(theme.primaryDark)
		}
		
		if !vm.selected{
		  LocationActionSearchView(vm: vm)
			 .transition(.move(edge: .leading))
		}else if let location = vm.selectedLocation{
		  MapFrameView(location: location)
			 .transition(.move(edge: .trailing))
			 .aspectRatio(1.3,contentMode: .fit)
		}
	 }
	 .padding()
  }
}

#Preview {
  Color.red
	 .sheet(isPresented: .constant(true)) {
		LocationSelectionSheet(){ _ in}
		  .presentationDetents([.medium])
	 }
}
