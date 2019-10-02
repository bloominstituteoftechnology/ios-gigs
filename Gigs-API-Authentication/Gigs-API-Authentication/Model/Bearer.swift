//
//  Bearer.swift
//  Gigs-API-Authentication
//
//  Created by Jonalynn Masters on 10/2/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import Foundation

struct Bearer: Codable {
    let id: Int
    let token: String
    let userID: Int
}
