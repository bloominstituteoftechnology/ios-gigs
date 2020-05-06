//
//  Gig.swift
//  Gigs
//
//  Created by morse on 5/9/19.
//  Copyright © 2019 morse. All rights reserved.
//

import Foundation

struct Gig: Codable {
    let title: String
    let dueDate: Date // ISO 8601
    let description: String
}
