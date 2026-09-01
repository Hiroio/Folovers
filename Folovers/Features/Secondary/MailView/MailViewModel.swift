//
//  MailViewModel.swift
//  Folovers
//
//  Created by user on 26.08.2026.
//

import Foundation


@Observable
final class MailViewModel{
  
  var selectedLetter: MailModel? = nil
  var mailState: MailType = .received

  var mails: [MailModel] {
	 mailManager.mails
  }

  var sentMails: [MailModel] {
	 mailManager.sentMails
  }

  var profiles: [String: UserDocument]{
	 connectionManager.profiles
  }

  private let mailManager = MailManager.shared
  private let connectionManager = ConnectionManager.shared

//  Newest first - Firestore hands them back unordered
  var letters: [MailModel] {
	 let list = mailState == .received ? mails : sentMails
	 return list.sorted(by: { $0.createdAt > $1.createdAt })
  }

  var unreadCount: Int {
	 mails.filter({ $0.status != .seen }).count
  }

//  Whoever is on the other side of the letter. Not a connection means "Unknown User"
  func counterpart(for mail: MailModel) -> UserDocument {
	 let uid = mailState == .received ? mail.createdBy : mail.createdFor
	 return ConnectionManager.knownUser(for: uid)
  }
}


extension MailViewModel{
  func markAsSeen(mail: MailModel){
	 var toEdit = mail
	 
	 toEdit.status = .seen
	 mailManager.editMail(mail: toEdit)
  }
  
  
  func deleteMail(mail: MailModel){
	 mailManager.deleteMail(mail: mail)
  }
  
  func open(letter: MailModel){
	 if mailState == .received && letter.status != .seen{
		markAsSeen(mail: letter)
	 }

	 NavigationManager.shared.addPopUp(.letter(letter))
  }

  func reply(to userId: String){
	 NavigationManager.shared.addPopUp(.letterCreation(to: userId))
  }
}
