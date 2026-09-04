//
//  SpriteViewModel.swift
//  Folovers
//
//  Created by user on 11.08.2026.
//

import SwiftUI
import SpritePackage

@Observable
final class SpriteViewModel {
  static let nativeSize = CGSize(width: 32, height: 32)
  static let displayScale: CGFloat = 3
  static let displaySize: CGSize = CGSize(width: nativeSize.width * displayScale, height: nativeSize.height * displayScale)

  let size: CGSize?
  let controller: CharacterController
  var number: Int = 0
  var action: SpriteActions

//  Travel for choreographed moods. The sprite itself never moves, the view offsets it
  var offsetX: CGFloat = 0

  @ObservationIgnored
  private var animationTask: Task<Void, Never>? = nil

  init(config: CharacterConfig, action: SpriteActions, controller: CharacterController?, size: CGSize? = nil){
	 self.size = size
	 if let controller{
		self.controller = controller
		self.action = action
	 }else{
		self.controller = CharacterController(config: config)
		self.action = action
	 }
	 initialize()
  }



//  Restart from scratch with a new action. Cancels whatever was playing
  func play(_ action: SpriteActions){
	 animationTask?.cancel()
	 animationTask = nil

	 self.action = action
	 offsetX = 0
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
		startIdleLoadingAnimation()
	 case .preview:
		controller.showPreview()
	 case .happy:
		startHappyAnimation()
	 case .awkward:
		startAwkwardAnimation()
	 case .sad:
		startSadAnimation()
	 case .angry:
		startAngryAnimation()
	 }
  }
  
}

extension SpriteViewModel{
  func startIdleAnimation() {
	 controller.play(.idle)
  }
  
//  LoadingView still positions the sprite off of `number` for this action via
//  SpriteActions.xPosition, so the stepping stays exactly as it was
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

//  idleLoading is never positioned off of `number` (SpriteActions.xPosition
//  has no case for it), so this is free to just keep the legs moving for as
//  long as StandartLoadingView's bar takes to cross - kept in sync with that
//  view's travelDuration by hand, same as hop()/walkStep() are tuned to SpritePackage
  func startIdleLoadingAnimation(){
	 animationTask = Task{
		let duration = 1.5
		let cycle = AnimationTrigger.walk().duration
		var elapsed = 0.0

		while elapsed < duration{
		  guard !Task.isCancelled else { return }

		  controller.play(.walk(.right))

		  let step = min(cycle, duration - elapsed)
		  try? await Task.sleep(for: .seconds(step))
		  elapsed += step
		}

		guard !Task.isCancelled else { return }
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
  
//  2 hops left, 4 right, 2 left - lands back in the centre, then idle
  func startHappyAnimation(){
	 let steps: [(direction: Direction, count: Int)] = [(.left, 2), (.right, 4), (.left, 2)]

	 animationTask = Task{
		var travelled = 0

		for step in steps{
		  for _ in 1...step.count{
			 guard !Task.isCancelled else { return }

			 travelled += step.direction == .left ? -1 : 1
			 await hop(to: travelled, direction: step.direction)
		  }
		}

		guard !Task.isCancelled else { return }

		withAnimation{
		  offsetX = 0
		}
		controller.play(.idle)
		action = .idle
	 }
  }

//  Plays forward, holds, then unwinds. The character stays put
  func startSadAnimation(){
	 playInPlace(.sad)
  }

//  7 frames, plays through once. The character stays put
  func startAngryAnimation(){
	 playInPlace(.angry)
  }

//  Runs a standing animation for its own length, then settles back into idle
  private func playInPlace(_ trigger: AnimationTrigger){
	 animationTask = Task{
		controller.play(trigger)

		try? await Task.sleep(for: .seconds(trigger.duration))
		guard !Task.isCancelled else { return }

		controller.play(.idle)
		action = .idle
	 }
  }

//  1 step left, 2 right, 2 left, 2 right, 1 left - ends where it started
  func startAwkwardAnimation(){
	 let steps: [(direction: Direction, count: Int)] = [(.left, 1), (.right, 2), (.left, 2), (.right, 2), (.left, 1)]

	 animationTask = Task{
		var travelled = 0

		for step in steps{
		  for _ in 1...step.count{
			 guard !Task.isCancelled else { return }

			 travelled += step.direction == .left ? -1 : 1
			 await walkStep(to: travelled, direction: step.direction)
		  }
		}

		guard !Task.isCancelled else { return }

		withAnimation{
		  offsetX = 0
		}
		controller.play(.idle)
		action = .idle
	 }
  }

//  One step, split over the art's two footfalls: move 0.2, wait 0.25, twice
  private func walkStep(to travelled: Int, direction: Direction) async {
	 let distance: CGFloat = 25

	 controller.play(.walk(direction))

	 let start = offsetX
	 let target = CGFloat(travelled) * distance

	 for half in 1...2{
		guard !Task.isCancelled else { return }

		withAnimation(.linear(duration: 0.36)){
		  offsetX = start + (target - start) * CGFloat(half) / 2
		}

		try? await Task.sleep(for: .seconds(0.41))
	 }
  }

//  One hop. The sprite art already lifts the character, so only the sideways
//  travel is animated here. The beat is the jump's own length, otherwise the
//  next hop restarts it and the middle frames never show
  private func hop(to travelled: Int, direction: Direction) async {
	 let distance: CGFloat = 18

	 controller.play(.jump(direction))
	 
	 try? await Task.sleep(for: .seconds(0.3))
	 withAnimation(.easeInOut(duration: 0.4)){
		offsetX = CGFloat(travelled) * distance
	 }

	 try? await Task.sleep(for: .seconds(0.65))
  }
}
