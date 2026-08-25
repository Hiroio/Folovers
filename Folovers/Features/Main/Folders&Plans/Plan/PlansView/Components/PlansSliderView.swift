//
//  PlansSliderView.swift
//  Folovers
//
//  Created by user on 16.08.2026.
//

import SwiftUI

struct PlansSliderView: View {
  @Environment(\.theme) var theme
  let plans: [PlanCard]
  let state: PlanType
  var onCreate: () -> Void = {}
  @State private var currentIndex: Int = 0
  @State private var dragOffset: CGFloat = 0

  private let visiblePeekCount = 3
  private let peekStep: CGFloat = 85
  private let exitDistance: CGFloat = 500
  private let dragThreshold: CGFloat = 110
  private let rubberBand: CGFloat = 0.3
  private let exitMinScale: CGFloat = 0.85

  var body: some View {
	 ZStack() {
		ForEach(renderedIndices, id: \.self) { index in
		  let position = effectivePosition(for: index)

		  Group{
//			 The last item in the stack is always the creation card
			 if index < plans.count{
				PlanCardView(plan: plans[index])
				  .onTapGesture {
					 withAnimation {
						NavigationManager.shared.plan = plans[index]
					 }
				  }
			 }else{
				CreationPlanCard()
				  .onTapGesture {
					 withAnimation {
						onCreate()
					 }
				  }
			 }
		  }
		  .scaleEffect(scale(for: position))
		  .offset(y: offset(for: position))
		  .opacity(opacity(for: position))
		  .zIndex(Double(-position))
		  .allowsHitTesting(index == currentIndex)
		  .gesture(index == currentIndex ? dragGesture : nil)
		}
	 }
	 .padding(position, 40)
	 .overlay(alignment: state == .plans ? .trailing : .leading) {
		if itemCount > 1 {
		  ScrubberView(count: itemCount, currentIndex: $currentIndex)
			 .padding(position, 4)
		}else {
		  Capsule()
			 .fill(theme.primary)
			 .frame(width: 6, height: 20)
			 .padding(position, 4)
		}
	 }
	 .animation(.easeInOut, value: currentIndex)

  }

  var position: Edge.Set{
	 state == .plans ? .trailing : .leading
  }
}


#Preview {
  ZStack {
	 ThemePalette.basic.background.ignoresSafeArea()
	 let list: [PlanCard] = Array(PlanCard.plans())
	 let list2: [PlanCard] = Array(PlanCard.plans())
	 let combined = list + list2
	 PlansSliderView(plans: [], state: .plans)
		.environment(\.theme, .basic)
		.padding()
  }
}



private extension PlansSliderView {

  var itemCount: Int { plans.count + 1 }

  var renderedIndices: [Int] {
	 let lower = max(currentIndex - 1, 0)
	 let upper = min(currentIndex + visiblePeekCount + 1, itemCount - 1)
	 guard lower <= upper else { return [] }
	 return Array(lower...upper)
  }

  var dragProgress: CGFloat {
	 (dragOffset / exitDistance).clamped(to: -1...1)
  }

  func effectivePosition(for index: Int) -> CGFloat {
	 CGFloat(index - currentIndex) - dragProgress
  }
  
  
  
  func offset(for position: CGFloat) -> CGFloat {
	 if position >= 0 {
		let clamped = min(position, CGFloat(visiblePeekCount))
		return -clamped * peekStep
	 } else {
		let t = min(-position, 1)
		return t * exitDistance
	 }
  }

  func scale(for position: CGFloat) -> CGFloat {
	 guard position < 0 else { return 1 }
	 let t = min(-position, 1)
	 return 1 - t * (1 - exitMinScale)
  }

  func opacity(for position: CGFloat) -> Double {
	 guard position < 0 else { return 1 }
	 let t = min(-position, 1)
	 return Double(1 - t)
  }

  var dragGesture: some Gesture {
	 DragGesture()
		.onChanged { value in
		  let translation = value.translation.height
		  let goingForwardPastEnd = translation > 0 && currentIndex >= itemCount - 1
		  let goingBackwardPastStart = translation < 0 && currentIndex <= 0
		  dragOffset = (goingForwardPastEnd || goingBackwardPastStart) ? translation * rubberBand : translation
		}
		.onEnded { value in
		  let translation = value.translation.height
		  if translation > dragThreshold, currentIndex < itemCount - 1 {
			 commit(direction: 1)
		  } else if translation < -dragThreshold, currentIndex > 0 {
			 commit(direction: -1)
		  } else {
			 withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
				dragOffset = 0
			 }
		  }
		}
  }

  func commit(direction: Int) {
	 let target = direction > 0 ? exitDistance : -exitDistance
	 withAnimation(.easeOut(duration: 0.32)) {
		dragOffset = target
	 } completion: {
		currentIndex += direction
		dragOffset = 0
	 }
  }
}




private struct ScrubberView: View {
  @Environment(\.theme) var theme
  let count: Int
  @Binding var currentIndex: Int

  @State private var isDragging = false
  @State private var dragStartIndex = 0
  @State private var dragBaselineY: CGFloat = 0
  @State private var edgeDirection: Int?
  @State private var autoScrollTask: Task<Void, Never>?

  private let dotSize: CGFloat = 6
  private let activeDotHeight: CGFloat = 20
  private let spacing: CGFloat = 8
  private let stepHeight: CGFloat = 9
  private let edgeThreshold: CGFloat = 24
  private let stepInterval: Duration = .milliseconds(150)

  var body: some View {
	 GeometryReader { geo in
		VStack(spacing: spacing) {
		  ForEach((0..<count).reversed(), id: \.self) { dot in
			 Capsule()
				.fill(dot == currentIndex ? theme.primaryDark : theme.secondaryText)
				.frame(
				  width: dot == currentIndex && isDragging ? dotSize + 1 : dotSize,
				  height: dot == currentIndex ? activeDotHeight + (isDragging ? 1 : 0) : dotSize
				)
		  }
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
		.contentShape(Rectangle())
		.gesture(
		  DragGesture(minimumDistance: 2)
			 .onChanged { value in
				guard count > 1 else { return }
				if !isDragging {
				  isDragging = true
				  dragStartIndex = currentIndex
				  dragBaselineY = value.location.y
				}

				let atTop = value.location.y <= edgeThreshold
				let atBottom = value.location.y >= geo.size.height - edgeThreshold

				if atTop || atBottom {
				  let direction = atTop ? 1 : -1
				  if edgeDirection != direction {
					 edgeDirection = direction
					 autoScrollTask?.cancel()
					 autoScrollTask = Task { await runAutoScroll(direction: direction) }
				  }
				} else {
				  if edgeDirection != nil {
					 edgeDirection = nil
					 autoScrollTask?.cancel()
					 dragStartIndex = currentIndex
					 dragBaselineY = value.location.y
				  }
				  let delta = dragBaselineY - value.location.y
				  let steps = (delta / stepHeight).rounded()
				  let newIndex = min(max(dragStartIndex + Int(steps), 0), count - 1)
				  if newIndex != currentIndex {
					 withAnimation(){
						currentIndex = newIndex
					 }
				  }
				}
			 }
			 .onEnded { _ in
				isDragging = false
				edgeDirection = nil
				autoScrollTask?.cancel()
				autoScrollTask = nil
			 }
		)
	 }
	 .frame(width: 20)
  }

  private func runAutoScroll(direction: Int) async {
	 while !Task.isCancelled {
		let newIndex = currentIndex + direction
		guard newIndex >= 0, newIndex <= count - 1 else { break }
		withAnimation(.easeOut(duration: 0.15)) {
		  currentIndex = newIndex
		}
		try? await Task.sleep(for: stepInterval)
	 }
  }
}

private extension Comparable {
  func clamped(to range: ClosedRange<Self>) -> Self {
	 min(max(self, range.lowerBound), range.upperBound)
  }
}
