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
  
  var profiles: [String: UserDocument] = [:]

  @ObservationIgnored
  private var inFlight: Set<String> = []

  @ObservationIgnored
  private let maxConcurrentProfileLoads = 15

}


// MARK: ---------- -=| Connections |=- ---------------------
extension ConnectionManager{

  func getConnections() async throws -> [ConnectionModel]{
	 guard let id = AuthManager.shared.id else { throw FirestoreError.operationNotAllowed }

	 let endpoint = ConnectionEndpoint(action: .fetchAll(userId: id))

	 let connections: [ConnectionModel] = try await FirestoreService.request(endpoint)

	 getUsersProfiles(connections: connections, uid: id)

	 return connections
  }

  func createConnection(_ connection: ConnectionModel) async throws {
	 let endpoint = ConnectionEndpoint(action: .create(connection))

	 try await FirestoreService.request(endpoint)
  }


  func update(_ connection: ConnectionModel) async throws {
	 let endpoint = ConnectionEndpoint(action: .update(connection))

	 try await FirestoreService.request(endpoint)
  }


  func delete(_ connection: ConnectionModel) async throws {
	 let endpoint = ConnectionEndpoint(action: .delete(connection))

	 try await FirestoreService.request(endpoint)
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
