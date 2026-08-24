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
	 step: Binding<Int>? = nil,
	 size: CGSize? = nil
  ){
	 self._vm = State(
		wrappedValue: SpriteViewModel(
		  config: config,
		  action: action,
		  controller: controller,
		  size: size
		)
	 )
	 self.step = step
  }

  var body: some View {
	 CharacterView(controller: vm.controller)
		.frame(width: vm.size?.width ?? SpriteViewModel.displaySize.width, height: vm.size?.height ?? SpriteViewModel.displaySize.height)
		.onChange(of: vm.number) { _, newValue in
		  step?.wrappedValue = newValue
		}
  }
}

#Preview {
  SpriteView(action: .idle)
}
