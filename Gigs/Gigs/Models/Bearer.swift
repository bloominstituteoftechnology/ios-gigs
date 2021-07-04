//
//  Bearer.swift
//  Gigs
//
//  Created by Jeffrey Santana on 8/7/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

struct Bearer: Codable {
	let token: String
	let userId: Int
}
