//
//  Bearer.swift
//  Gigs
//
//  Created by Casualty on 9/10/19.
//  Copyright © 2019 Thomas Dye. All rights reserved.
//

import Foundation

struct Bearer: Codable {
    let id: Int
    let token: String
    let userId: Int
}
