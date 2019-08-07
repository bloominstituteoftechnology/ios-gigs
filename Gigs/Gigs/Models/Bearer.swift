//
//  Bearer.swift
//  Gigs
//
//  Created by Alex Shillingford on 8/7/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import Foundation

struct Bearer: Codable {
    var id: Int
    var token: String
    var userId: Int
}
