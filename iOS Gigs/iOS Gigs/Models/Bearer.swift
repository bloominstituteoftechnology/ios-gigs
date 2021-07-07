//
//  Bearer.swift
//  iOS Gigs
//
//  Created by Vici Shaweddy on 9/10/19.
//  Copyright © 2019 Vici Shaweddy. All rights reserved.
//

import Foundation

struct Bearer: Codable {
    let id: Int
    let token: String
    let userId: Int
}
