//
//  ConnectionManager.swift
//  Folovers
//
//  Created by user on 20.08.2026.
//

import Foundation

@MainActor
@Observable
final class ConnectionManager{
  static let shared = ConnectionManager()
  
  var connections: [ConnectionModel] = []
  var profiles: [String: UserDocument] = [:]

//  Loading the list itself
  var connectionsError: FirestoreError? = nil
//  Creating / updating / deleting a single connection
  var requestError: FirestoreError? = nil

  @ObservationIgnored
  private var inFlight: Set<String> = []

  @ObservationIgnored
  private let maxConcurrentProfileLoads = 15

  @ObservationIgnored
  private var task: Task<Void, Error>? = nil
}


// MARK: ---------- -=| Connections |=- ---------------------
extension ConnectionManager{

  func getConnections() async {
	 connectionsError = nil

	 guard let id = AuthManager.shared.id else {
		connectionsError = .operationNotAllowed
		return
	 }

	 do{
		let endpoint = ConnectionEndpoint(action: .fetchAll(userId: id))
		let connections: [ConnectionModel] = try await FirestoreService.request(endpoint)

		self.connections = connections
		getUsersProfiles(connections: connections, uid: id)
	 }catch{
		connectionsError = mapError(error)
	 }
  }
  
  func createConnection(_ connection: ConnectionModel) async {
	 await performRequest(action: .create(connection))
  }


  func update(_ connection: ConnectionModel) async {
	 await performRequest(action: .update(connection))
  }


  func delete(_ connection: ConnectionModel) async {
	 await performRequest(action: .delete(connection))
  }

  private func performRequest(action: ConnectionEndpoint.Action) async {
	 requestError = nil

	 do{
		let endpoint = ConnectionEndpoint(action: action)
		try await FirestoreService.request(endpoint)
	 }catch{
		requestError = mapError(error)
	 }
  }
  
  
  func startListener() {
	 guard task == nil else { return }
	 connectionsError = nil

	 guard let id = AuthManager.shared.id else {
		connectionsError = .operationNotAllowed
		return
	 }
	 
	 self.task = Task{
		do{
		  let endpoint = ConnectionEndpoint(action: .listener(userId: id))
		  
		  for try await values: [ConnectionModel] in FirestoreService.stream(endpoint) {
			 connections = values
			 if !connections.isEmpty{
				getUsersProfiles(connections: connections, uid: id)
			 }
		  }
		}catch{
		  let error = mapError(error)
		  self.connectionsError = error
		}
	 }
  }
  
  func stopListener(){
	 self.task?.cancel()
	 self.task = nil
  }

//  Resubscribes from scratch. For "Try Again" and for rebinding to another uid
  func restartListener(){
	 stopListener()
	 startListener()
  }

  @discardableResult
  func mapError(_ error: Error) -> FirestoreError{
	 guard let error = error as? FirestoreError else { return .unknownError }
	 return error
  }
}



// MARK: ---------- -=| PROFILES |=- ---------------------
extension ConnectionManager{
//	 Warms up profiles for the whole list. Safe for any amount of connections
  func getUsersProfiles(connections: [ConnectionModel], uid: String){
	 let ids = Set(connections.flatMap({ $0.users }).filter({ $0 != uid }))

	 Task{
		await prefetchProfiles(uids: Array(ids))
	 }
  }

//	 Single profile for one row. Used by views that scrolled ahead of the prefetch
  func loadProfileIfNeeded(uid: String) async {
	 guard profiles[uid] == nil, !inFlight.contains(uid) else { return }

	 inFlight.insert(uid)
	 defer { inFlight.remove(uid) }

	 if let user = await Self.fetchProfile(uid: uid){
		profiles[uid] = user
	 }
  }

  private func prefetchProfiles(uids: [String]) async {
	 let missing = uids.filter({ profiles[$0] == nil && !inFlight.contains($0) })

	 guard !missing.isEmpty else { return }

	 await withTaskGroup(of: (String, UserDocument?).self){ taskGroup in

//		Only maxConcurrentProfileLoads requests are in flight at any moment
		var next = min(maxConcurrentProfileLoads, missing.count)

		for index in 0..<next{
		  let uid = missing[index]
		  inFlight.insert(uid)
		  taskGroup.addTask{
			 (uid, await Self.fetchProfile(uid: uid))
		  }
		}

		for await (uid, user) in taskGroup{
		  inFlight.remove(uid)

//		  Each profile lands in the dictionary as soon as it arrives
		  if let user{
			 profiles[uid] = user
		  }

//		  One finished, one starts
		  if next < missing.count{
			 let nextUid = missing[next]
			 next += 1

			 inFlight.insert(nextUid)
			 taskGroup.addTask{
				(nextUid, await Self.fetchProfile(uid: nextUid))
			 }
		  }
		}
	 }
  }

  private nonisolated static func fetchProfile(uid: String) async -> UserDocument? {
	 let endpoint = UserEndpoint.getUser(id: uid)
	 return try? await FirestoreService.request(endpoint, cacheFirst: true)
  }
}
