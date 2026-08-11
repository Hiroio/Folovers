//
//  SpriteView.swift
//  Folovers
//
//  Created by user on 11.08.2026.
//

import SwiftUI
import SpritePackage

struct SpriteView: View {
  @State private var vm: SpriteViewModel
  
  init(action: SpriteActions){
	 self._vm = State(wrappedValue: SpriteViewModel(config: .default, action: action))
  }
  
  var body: some View {
	 GeometryReader { geo in
		  CharacterView(controller: vm.controller)
			 .scaleEffect(SpriteViewModel.displayScale)
			 .frame(width: SpriteViewModel.displaySize.width, height: SpriteViewModel.displaySize.height)
			 .position(
				x: vm.action.xPosition(step: vm.number, containerWidth: geo.size.width, spriteWidth: SpriteViewModel.displaySize.width),
				y: geo.size.height / 2)
	 }
	 .animation(.easeInOut(duration: vm.action.animationDuration), value: vm.number)
	 .frame(maxHeight: .infinity)
  }
}

#Preview {
  SpriteView(action: .walk)
}
