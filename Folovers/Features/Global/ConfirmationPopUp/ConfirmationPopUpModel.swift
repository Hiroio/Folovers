//
//  ConfirmationPopUpModel.swift
//  Folovers
//
//  Created by user on 03.09.2026.
//

import Foundation

//  Generic "are you sure?" payload. Any screen can push .confirmation(.init(...))
//  onto NavigationManager instead of building its own dialog
struct ConfirmationPopUpModel{
  let text: String
//  var, not let - a `let` with a default value is fixed at declaration and
//  drops out of the memberwise init entirely, so it could never be overridden
  var confirmText: String = "Delete"
  var isDestructive: Bool = true
  let onConfirm: () -> Void
}
