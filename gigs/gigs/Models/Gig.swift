//
//  Gig.swift
//  gigs
//
//  Created by John McCants on 7/17/20.
//  Copyright © 2020 John McCants. All rights reserved.
//

import Foundation

struct Gig: Codable, Equatable {
    let title: String
    let description: String
    let dueDate: Date
}
