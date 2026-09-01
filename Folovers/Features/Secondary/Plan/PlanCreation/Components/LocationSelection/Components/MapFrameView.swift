//
//  MapFrameView.swift
//  Folovers
//
//  Created by user on 19.08.2026.
//

import SwiftUI
import MapKit

struct MapFrameView: View {
  @Environment(\.theme) var theme
  @State private var mapPosition: MapCameraPosition
  @State private var spanDelta: Double
  private let coordinate: CLLocationCoordinate2D
  private let locationName: String

  private let minSpanDelta: Double = 0.005
  private let maxSpanDelta: Double = 5

  init(location: PlanLocation){
	 let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
	 let initialSpanDelta = 0.025
	 let span = MKCoordinateSpan(latitudeDelta: initialSpanDelta, longitudeDelta: initialSpanDelta)
	 let region = MKCoordinateRegion(center: coordinate, span: span)
	 self._mapPosition = State(wrappedValue: MapCameraPosition.region(region))
	 self._spanDelta = State(wrappedValue: initialSpanDelta)
	 self.coordinate = coordinate
	 self.locationName = location.name
  }

  var body: some View {
	 Map(position: $mapPosition){
		Annotation(locationName, coordinate: coordinate) {
		  Image(systemName: "drop.fill")
			 .font(.title2)
			 .rotationEffect(Angle(degrees: 180))
			 .foregroundStyle(.red)
		}
	 }
	 .allowsHitTesting(false)
	 .frame(maxWidth: .infinity, maxHeight: .infinity)
	 .overlay(alignment: .topTrailing){
		VStack(spacing: 15){
		  Button{
			 zoom(by: 0.5)
		  }label:{
			 Image(systemName: "plus")
				.containerRelativeFrame(.vertical, count: 30, spacing: 0)
				.border(10)
		  }
		  .disabled(spanDelta <= minSpanDelta)

		  Button{
			 zoom(by: 2)
		  }label:{
			 Image(systemName: "minus")
				.containerRelativeFrame(.vertical, count: 30, spacing: 0)
				.border(10)
		  }
		  .disabled(spanDelta >= maxSpanDelta)
		}
		.font(.title2)
		.padding(5)
		.foregroundStyle(theme.primary)
	 }
  }
}

extension MapFrameView{
  private func zoom(by factor: Double){
	 let newSpanDelta = min(max(spanDelta * factor, minSpanDelta), maxSpanDelta)
	 guard newSpanDelta != spanDelta else { return }

	 spanDelta = newSpanDelta
	 let span = MKCoordinateSpan(latitudeDelta: newSpanDelta, longitudeDelta: newSpanDelta)
	 withAnimation{
		mapPosition = .region(MKCoordinateRegion(center: coordinate, span: span))
	 }
  }
}

#Preview {
  MapFrameView(location: PlanLocation(name: "Some", latitude: 53.498686, longitude: -10.098405))
	 .environment(\.theme, .basic)
}
