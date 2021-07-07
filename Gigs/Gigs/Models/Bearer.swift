//
//  Bearer.swift
//  Gigs
//
//  Created by Michael Redig on 5/9/19.
//  Copyright © 2019 Michael Redig. All rights reserved.
//

import Foundation

struct Bearer: Codable {
	let id: Int
	let token: String
	let userId: Int
}
