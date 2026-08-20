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
  private var step: Binding<Int>?

  init(
	 action: SpriteActions,
	 config: CharacterConfig = .standart,
	 controller: CharacterController? = nil,
	 step: Binding<Int>? = nil
  ){
	 self._vm = State(
		wrappedValue: SpriteViewModel(
		  config: .standart,
		  action: action,
		  controller: controller
		)
	 )
	 self.step = step
  }

  var body: some View {
	 CharacterView(controller: vm.controller)
		.scaleEffect(SpriteViewModel.displayScale)
		.frame(width: SpriteViewModel.displaySize.width, height: SpriteViewModel.displaySize.height)
		.onChange(of: vm.number) { _, newValue in
		  step?.wrappedValue = newValue
		}
  }
}

#Preview {
  SpriteView(action: .idle)
}
