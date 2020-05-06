//
//  Bearer.swift
//  Gigs
//
//  Created by Joshua Rutkowski on 1/21/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import Foundation

struct Bearer: Codable {
    let id: Int
    let token: String
    let userId: Int
}
