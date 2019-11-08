//
//  Gig.swift
//  Gigs
//
//  Created by Joseph Rogers on 11/7/19.
//  Copyright © 2019 Joseph Rogers. All rights reserved.
//

import Foundation

struct Gig: Codable, Equatable {
    var title: String
    var description: String
    var dueDate: Date
}
