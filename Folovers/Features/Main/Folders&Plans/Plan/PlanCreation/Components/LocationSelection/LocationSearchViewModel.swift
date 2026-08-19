//
//  LocationSearchViewModel.swift
//  Folovers
//
//  Created by user on 19.08.2026.
//

import Foundation
import MapKit
import UIKit

enum LocationCandidate: Identifiable{
  case completion(MKLocalSearchCompletion)
  case coordinate(PlanLocation)

  var id: String{
	 switch self{
	 case .completion(let completion): completion.title + completion.subtitle
	 case .coordinate(let location): "\(location.latitude),\(location.longitude)"
	 }
  }

  var title: String{
	 switch self{
	 case .completion(let completion): completion.title
	 case .coordinate(let location): location.name
	 }
  }

  var subtitle: String{
	 switch self{
	 case .completion(let completion): completion.subtitle
	 case .coordinate(let location): "\(location.latitude), \(location.longitude)"
	 }
  }
}

@Observable
final class LocationSearchViewModel: NSObject{
  var searchText: String = ""{
	 didSet{
		completer.queryFragment = searchText
	 }
  }

  var latText: String = ""{
	 didSet{ handleCoordinatesChange() }
  }
  var lonText: String = ""{
	 didSet{ handleCoordinatesChange() }
  }

  var selectedLocation: PlanLocation? = nil
  var selected: Bool = false

  private var nameResults: [MKLocalSearchCompletion] = []
  private var coordinateResult: LocationCandidate? = nil

  var results: [LocationCandidate]{
	 var items: [LocationCandidate] = []
	 if let coordinateResult{ items.append(coordinateResult) }
	 items.append(contentsOf: nameResults.map{ .completion($0) })
	 return items
  }

  @ObservationIgnored
  private lazy var completer: MKLocalSearchCompleter = {
	 let completer = MKLocalSearchCompleter()
	 completer.delegate = self
	 completer.resultTypes = [.address, .pointOfInterest]
	 return completer
  }()

  @ObservationIgnored
  private var geocodeTask: Task<Void, Never>? = nil
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate{
  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
	 nameResults = completer.results
  }

  func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
	 print("DEBUG: Location search failed: \(error)")
  }
}

extension LocationSearchViewModel{
  func selectCandidate(_ candidate: LocationCandidate){
	 switch candidate{
	 case .completion(let completion):
		resolveCompletion(completion)
	 case .coordinate(let location):
		selectedLocation = location
		selected = true
	 }
  }

  private func resolveCompletion(_ completion: MKLocalSearchCompletion){
	 let request = MKLocalSearch.Request(completion: completion)
	 let search = MKLocalSearch(request: request)

	 Task{
		do{
		  let response = try await search.start()
		  guard let mapItem = response.mapItems.first else { return }
		  let coordinate = mapItem.placemark.coordinate
		  let name = mapItem.name ?? completion.title

		  selectedLocation = PlanLocation(name: name, latitude: coordinate.latitude, longitude: coordinate.longitude)
		  selected = true
		}catch{
		  print("DEBUG: Failed to resolve location: \(error)")
		}
	 }
  }

  private func handleCoordinatesChange(){
	 geocodeTask?.cancel()

	 guard !latText.isEmpty, !lonText.isEmpty,
			 let latitude = Double(latText), (-90...90).contains(latitude),
			 let longitude = Double(lonText), (-180...180).contains(longitude) else{
		coordinateResult = nil
		return
	 }

	 geocodeTask = Task{
		let location = CLLocation(latitude: latitude, longitude: longitude)
		let name: String
		if let placemark = try? await CLGeocoder().reverseGeocodeLocation(location).first{
		  name = placemark.name ?? placemark.locality ?? "\(latitude), \(longitude)"
		}else{
		  name = "\(latitude), \(longitude)"
		}

		guard !Task.isCancelled else { return }
		coordinateResult = .coordinate(PlanLocation(name: name, latitude: latitude, longitude: longitude))
	 }
  }

  func pasteCoordinates(){
	 guard let string = UIPasteboard.general.string else { return }

	 let components = string
		.components(separatedBy: CharacterSet(charactersIn: ", "))
		.filter{ !$0.isEmpty }

	 guard components.count >= 2 else { return }

	 latText = components[0]
	 lonText = components[1]
  }
}
