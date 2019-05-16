//
//  Bearer.swift
//  ios-gigs
//
//  Created by Ryan Murphy on 5/16/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
//

import Foundation

struct Bearer: Codable {
    var id: String
    var token: String
    var userId: Int
}
