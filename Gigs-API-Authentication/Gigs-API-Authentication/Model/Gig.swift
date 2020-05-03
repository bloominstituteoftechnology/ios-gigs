//
//  Gig.swift
//  Gigs-API-Authentication
//
//  Created by Jonalynn Masters on 10/3/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import Foundation

struct Gig: Codable {
    let title: String
    let dueDate: Date
    let description: String
}
