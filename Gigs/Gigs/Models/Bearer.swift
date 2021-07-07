//
//  Bearer.swift
//  Gigs
//
//  Created by Angel Buenrostro on 8/24/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import Foundation

struct Bearer: Codable {
    let id: Int
    let token: String
    let userId: Int
}
