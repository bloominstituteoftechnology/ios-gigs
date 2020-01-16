//
//  Gig.swift
//  Gigs
//
//  Created by Jon Bash on 2019-10-31.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import Foundation

struct Gig: Codable, Equatable {
    var title: String
    var dueDate: Date
    var description: String
}
