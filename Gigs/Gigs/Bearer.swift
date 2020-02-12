//
//  Bearer.swift
//  Gigs
//
//  Created by Stephanie Ballard on 2/12/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import Foundation

struct Bearer: Codable {
    let token: String
    let id: Int
    let userId: Int
}
