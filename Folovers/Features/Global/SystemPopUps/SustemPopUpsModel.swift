//
//  SustemPopUpsModel.swift
//  Folovers
//
//  Created by user on 27.08.2026.
//

import Foundation
import SwiftUI

struct SystemPopUpModel{
  let id: UUID = UUID()
  let text: String
  let type: SystemPopUpType
}

extension SystemPopUpModel{
  static func get(_ type: SystemPopUpType,_ text: String = "") -> SystemPopUpModel{
	 if text.isEmpty{
		return .init(text: type.text, type: type)
	 }else{
		return .init(text: text, type: type)
	 }
  }
}



enum SystemPopUpType: String, Identifiable{
  case error, success, info, unkown
  
  var id: String{
	 self.rawValue
  }
  
  var text: String{
	 switch self {
	 case .error:
		"Some error appeard!"
	 case .success:
		"The action successfuly done!"
	 case .info:
		"There is some new messages here!"
	 case .unkown:
		"Something went wrong!"
	 }
  }
  
  var color: Color{
	 switch self {
	 case .error:
		  .red
	 case .success:
		  .green
	 case .info:
		  .blue
	 case .unkown:
		  .yellow
	 }
  }
  
  var systemIcon: String {
	 switch self {
	 case .error:
		"exclamationmark.octagon.fill"
	 case .success:
		"checkmark.square.fill"
	 case .info:
		"info.square.fill"
	 case .unkown:
		"questionmark.app.fill"
	 }
  }
}
