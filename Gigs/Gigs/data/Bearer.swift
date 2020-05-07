//
//  Bearer.swift
//  Gigs
//
//  Created by Vincent Hoang on 5/6/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import Foundation

struct Bearer: Codable {
    let id: Int
    let token: String
    let userId: Int
}
