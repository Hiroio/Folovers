//
//  SpriteViewModel.swift
//  Folovers
//
//  Created by user on 11.08.2026.
//

import Foundation
import SpritePackage

@Observable
final class SpriteViewModel {
  static let nativeSize = CGSize(width: 32, height: 32)
  static let displayScale: CGFloat = 3
  static let displaySize = CGSize(width: nativeSize.width * displayScale, height: nativeSize.height * displayScale)

  let controller: CharacterController
  var number: Int = 0
  var action: SpriteActions

  init(config: CharacterConfig, action: SpriteActions, controller: CharacterController?){
	 if let controller{
		self.controller = controller
		self.action = action
	 }else{
		self.controller = CharacterController(config: config, sceneSize: Self.displaySize)
		self.action = action
	 }
	 initialize()
  }



  func initialize(){
	 switch action {
	 case .idle:
		startIdleAnimation()
	 case .walk:
		animateWalk()
	 case .jump:
		animateJump()
	 case .loading:
		startLoadingAnimation()
	 case .idleLoading:
		startIdleAnimation()
	 case .preview:
		controller.showPreview()
	 }
  }
  
}

extension SpriteViewModel{
  func startIdleAnimation() {
	 controller.play(.idle)
  }
  
  func startLoadingAnimation(){
	 Task{
		controller.play(.walk(.right))
		for i in 1...SpriteActions.loading.sprites {
		  if i % 2 == 0 {
			 controller.play(.walk(.right))
		  }
		  number = i
		  try? await Task.sleep(nanoseconds: 400_000_000)
		}
		controller.play(.idle)
	 }
  }
  
  func animateWalk(){
	 Task{
		controller.play(.walk(.right))
		for i in 1...SpriteActions.walk.sprites {
		  if i % 2 == 0 {
			 controller.play(.walk(.right))
		  }
		  number = i
		  try? await Task.sleep(nanoseconds: 400_000_000)
		}
	 }
  }
  
  func animateJump(){
	 Task{
		for i in 1...SpriteActions.jump.sprites {
		  controller.play(.jump(.right))
		  try? await Task.sleep(nanoseconds: 500_000_000)
		  number = i
		  try? await Task.sleep(nanoseconds: 800_000_000)
		}
	 }
  }
}
