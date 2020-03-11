//
//  Gig.swift
//  Gigs
//
//  Created by Jesse Ruiz on 10/3/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct Gig: Codable, Equatable {
    let title: String
    let description: String
    let dueDate: Date
}
