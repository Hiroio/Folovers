//
//  MailModel.swift
//  Folovers
//
//  Created by user on 26.08.2026.
//

import Foundation


struct MailModel: FirestoreIdentifiable{
  var id: String
  var title: String
  var body: String
  var status: MailStatus
  var createdBy: String
  var createdFor: String
  var createdAt: Date
  
}



enum MailStatus: Codable{
  case sent, failed, seen
}
