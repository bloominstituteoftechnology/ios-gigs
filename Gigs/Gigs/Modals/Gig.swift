//
//  Gig.swift
//  Gigs
//
//  Created by Ahava on 5/18/20.
//  Copyright © 2020 Ahava. All rights reserved.
//

import Foundation

struct Gig: Codable, Equatable {
    var title: String
    var description: String
    var dueDate: Date
}
