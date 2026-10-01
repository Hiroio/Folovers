//
//  LetterCreationViewModel.swift
//  Folovers
//
//  Created by user on 26.08.2026.
//

import Foundation


@Observable
final class LetterCreationViewModel{
  let uid: String
//  Reply is stacked on top of the letter it answers - closing should drop
//  both, not just come back to the letter as if nothing happened
  let isReply: Bool
  var title: String = ""
  var body: String = ""
  var loading: Bool = false

  private let mailManager = MailManager.shared

  init(uid: String, isReply: Bool){
	 self.uid = uid
	 self.isReply = isReply
  }

//  Resolved without any network. Not a connection means "Unknown User"
  var recipient: UserDocument {
	 ConnectionManager.knownUser(for: uid)
  }

  var isKnown: Bool {
	 ConnectionManager.shared.profiles[uid] != nil || uid == AuthManager.shared.id
  }

//  An unknown recipient is fine - the uid is enough to deliver. Only the identity stays hidden
  var ableToSend: Bool {
	 !uid.isEmpty
	 && !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
	 && !body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

}

extension LetterCreationViewModel{
  func send(){
	 guard let id = AuthManager.shared.id, ableToSend else { return }

	 loading = true
	 defer { loading = false }

	 let mail = MailModel(
		id: "",
		title: title.trimmingCharacters(in: .whitespacesAndNewlines),
		body: body.trimmingCharacters(in: .whitespacesAndNewlines),
		status: .sent,
		createdBy: id,
		createdFor: uid,
		createdAt: .now
	 )

	 mailManager.createMail(mail: mail)
  }

  func close(){
	 NavigationManager.shared.popPopUp()

//	 Reply sits on top of the letter it answers - drop that too, landing back
//	 on the mailbox instead of the letter as if nothing happened
	 if isReply{
		NavigationManager.shared.popPopUp()
	 }
  }
}
