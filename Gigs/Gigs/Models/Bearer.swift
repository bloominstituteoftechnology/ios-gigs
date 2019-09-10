//
//  Bearer.swift
//  Gigs
//
//  Created by Bobby Keffury on 9/10/19.
//  Copyright © 2019 Bobby Keffury. All rights reserved.
//

import Foundation

struct Bearer: Codable {
    let id: Int
    let token: String
    let userId: Int
}
