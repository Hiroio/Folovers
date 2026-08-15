//
//  PhotoAttachment.swift
//  Folovers
//
//  Created by user on 15.08.2026.
//

import Foundation

struct PhotoAttachment: Codable {
	 var localPath: String?
	 var remoteUrl: String?
	 var thumbnailUrl: String?
	 var status: Bool
	 var uploadedBy: String
}
