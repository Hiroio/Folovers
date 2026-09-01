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
  var title: String = ""
  var body: String = ""
  var loading: Bool = false

  private let mailManager = MailManager.shared

  init(uid: String){
	 self.uid = uid
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

  var mailErrors: FirestoreError? {
	 mailManager.mailErrors
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
  }
}
