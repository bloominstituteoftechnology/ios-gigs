//
//  Gig.swift
//  Gigs
//
//  Created by Norlan Tibanear on 7/13/20.
//  Copyright © 2020 Norlan Tibanear. All rights reserved.
//

import Foundation

struct Gig: Codable, Equatable {
    let title: String
    let description: String
    let dueDate: Date
}
