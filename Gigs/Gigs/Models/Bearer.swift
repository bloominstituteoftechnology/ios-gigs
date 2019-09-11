//
//  Bearer.swift
//  Gigs
//
//  Created by Jessie Ann Griffin on 9/10/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import Foundation

struct Bearer: Codable {
    let id: Int
    let token: String
    let userId: Int
}
