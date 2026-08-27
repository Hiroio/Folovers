//
//  MailManager.swift
//  Folovers
//
//  Created by user on 26.08.2026.
//

import Foundation


@MainActor
@Observable
final class MailManager{
  static let shared = MailManager()
  
  var mails: [MailModel] = [] {
	 didSet{
		if mails.filter({$0.status == .sent}).count > 0{
		  NavigationManager.shared.addSystemUp(.get(.info, "You have received some letters"))
		}
	 }
  }
  var sentMails: [MailModel] = []
  
  var mailErrors: FirestoreError? = nil
  
  @ObservationIgnored
  private var task: Task<Void, Error>? = nil
  
  
  
  func initializeManager() {
	 startListener()
	 fetchSentLetters()
  }
  
  @discardableResult
  func mapError(_ error: Error) -> FirestoreError{
	 guard let error = error as? FirestoreError else { return .unknownError }
	 return error
  }
}

//Utility
extension MailManager{
  func fetchSentLetters(){
	 guard let id = AuthManager.shared.id else {return}
	 let endpoint = MailEndpoint(action: .fetchAll(userId: id))
	 Task{
		do{
		  let sent: [MailModel] = try await FirestoreService.request(endpoint)
		  self.sentMails = sent
		}catch{
//		  don't need to catch errors here
		}
	 }
  }
  
  
//  Create
  func createMail(mail: MailModel){
	 mailErrors = nil
	 let endPoint = MailEndpoint(action: .create(mail))
	 
	 Task{
		do{
		  try await FirestoreService.request(endPoint)
		  sentMails.append(mail)
		}catch{
		  self.mailErrors = mapError(error)
		}
	 }
  }
  
  
  
//  Edit/MakeSeen
  func editMail(mail: MailModel){
	 let endPoint = MailEndpoint(action: .update(mail))
	 
	 Task{
		do{
		  try await FirestoreService.request(endPoint)
		}catch{
		  self.mailErrors = mapError(error)
		}
	 }
  }
  
  
//  Delete
  func deleteMail(mail: MailModel){
	 let endPoint = MailEndpoint(action: .delete(mail))
	 
	 Task{
		do{
		  try await FirestoreService.request(endPoint)
		}catch{
		  self.mailErrors = mapError(error)
		  NavigationManager.shared.addSystemUp(.get(.error, "Could not delete the letter"))
		}
	 }
  }
}


//Listener
extension MailManager{
  func startListener() {
	 guard task == nil else { return }
	 mailErrors = nil
	 
	 guard let id = AuthManager.shared.id else {
		mailErrors = .operationNotAllowed
		return
	 }
	 
	 self.task = Task{
		do{
		  let endpoint = MailEndpoint(action: .listener(userId: id))
		  
		  for try await values: [MailModel] in FirestoreService.stream(endpoint) {
			 mails = values
		  }
		}catch{
		  let error = mapError(error)
		  self.mailErrors = error
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
  
  
}
