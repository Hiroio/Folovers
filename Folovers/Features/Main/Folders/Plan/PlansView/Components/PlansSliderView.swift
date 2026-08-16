//
//  PlansSliderView.swift
//  Folovers
//
//  Created by user on 16.08.2026.
//

import SwiftUI

struct PlansSliderView: View {
  let plans: [PlanCard]
  let state: PlanType
  @State private var currentIndex: Int = 0
  @State private var dragOffset: CGFloat = 0

  private let visiblePeekCount = 3
  private let peekStep: CGFloat = 85
  private let exitDistance: CGFloat = 500
  private let dragThreshold: CGFloat = 110
  private let rubberBand: CGFloat = 0.3
  private let exitMinScale: CGFloat = 0.85

  var body: some View {
	 ZStack(alignment: .top) {
		ForEach(renderedIndices, id: \.self) { index in
		  let position = effectivePosition(for: index)

		  PlanCardView(plan: plans[index])
			 .scaleEffect(scale(for: position))
			 .offset(y: offset(for: position))
			 .opacity(opacity(for: position))
			 .zIndex(Double(-position))
			 .allowsHitTesting(index == currentIndex)
			 .gesture(index == currentIndex ? dragGesture : nil)
		}
	 }
	 .padding(state == .plans ? .trailing : .leading, 35)
	 .overlay(alignment: state == .plans ? .trailing : .leading) {
		if plans.count > 1 {
		  ScrubberView(count: plans.count, currentIndex: $currentIndex)
			 .padding(.trailing, 4)
		}
	 }
  }
}

private extension PlansSliderView {

  var renderedIndices: [Int] {
	 guard !plans.isEmpty else { return [] }
	 let lower = max(currentIndex - 1, 0)
	 let upper = min(currentIndex + visiblePeekCount + 1, plans.count - 1)
	 guard lower <= upper else { return [] }
	 return Array(lower...upper)
  }

  var dragProgress: CGFloat {
	 (dragOffset / exitDistance).clamped(to: -1...1)
  }

  func effectivePosition(for index: Int) -> CGFloat {
	 CGFloat(index - currentIndex) - dragProgress
  }

  /// position 0 = active card (bottom, fully visible).
  /// position visiblePeekCount = furthest peek (top, only header visible).
  /// position < 0 = actively leaving the active slot (or arriving into it from
  /// below on a backward swipe) — slides further down/up, shrinking and fading
  /// as it goes. Peek cards just shuffle via offset alone, no scale/opacity.
  func offset(for position: CGFloat) -> CGFloat {
	 let activeOffset = CGFloat(visiblePeekCount) * peekStep
	 if position >= 0 {
		let clamped = min(position, CGFloat(visiblePeekCount))
		return activeOffset - clamped * peekStep
	 } else {
		let t = min(-position, 1)
		return activeOffset + t * exitDistance
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
		  let goingForwardPastEnd = translation > 0 && currentIndex >= plans.count - 1
		  let goingBackwardPastStart = translation < 0 && currentIndex <= 0
		  dragOffset = (goingForwardPastEnd || goingBackwardPastStart) ? translation * rubberBand : translation
	 }
		.onEnded { value in
		  let translation = value.translation.height
		  if translation > dragThreshold, currentIndex < plans.count - 1 {
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

/// Vertical dot indicator (capped at 10 dots, mapped proportionally for longer lists).
/// Dragging anywhere on it scrubs `currentIndex`.
private struct ScrubberView: View {
  let count: Int
  @Binding var currentIndex: Int

  private let dotSize: CGFloat = 6
  private let activeDotHeight: CGFloat = 20
  private let spacing: CGFloat = 8

  var body: some View {
	 GeometryReader { geo in
		// Index 0 renders at the bottom (matches the active card sitting at the
		// bottom of the stack); higher indices stack upward above it.
		VStack(spacing: spacing) {
		  ForEach((0..<count).reversed(), id: \.self) { dot in
			 Capsule()
				.fill(dot == currentIndex ? Color.primary : Color.secondary.opacity(0.3))
				.frame(width: dotSize, height: dot == currentIndex ? activeDotHeight : dotSize)
		  }
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
		.contentShape(Rectangle())
		.gesture(
		  DragGesture(minimumDistance: 0)
			 .onChanged { value in
				guard count > 1, geo.size.height > 0 else { return }
				let progress = min(max(value.location.y / geo.size.height, 0), 1)
				let newIndex = Int(((1 - progress) * CGFloat(count - 1)).rounded())
				if newIndex != currentIndex {
				  withAnimation(.easeOut(duration: 0.2)) {
					 currentIndex = newIndex
				  }
				}
			 }
		)
	 }
	 .frame(width: 20)
  }
}

private extension Comparable {
  func clamped(to range: ClosedRange<Self>) -> Self {
	 min(max(self, range.lowerBound), range.upperBound)
  }
}

#Preview {
  ZStack {
	 ThemePalette.basic.background.ignoresSafeArea()
	 let list: [PlanCard] = Array(PlanCard.plans())
	 let list2: [PlanCard] = Array(PlanCard.plans())
	 let combined = list + list2
	 PlansSliderView(plans: combined, state: .plans)
		.environment(\.theme, .basic)
		.padding()
  }
}
