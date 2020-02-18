//
//  Bearer.swift
//  Gigs
//
//  Created by John Kouris on 9/9/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import Foundation

struct Bearer: Codable {
    var id: Int
    var token: String
    var userId: Int
}
