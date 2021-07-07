//
//  Gig.swift
//  Gigs
//
//  Created by Jorge Alvarez on 1/16/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import Foundation

struct Gig: Codable {
    var title: String
    var description: String
    var dueDate: Date // "ISO 8601" for .dateDecodingStrategy JSONDecoder
}
