//
//  Gig.swift
//  Gigs
//
//  Created by Jessie Ann Griffin on 11/7/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import Foundation

struct Gig: Codable, Equatable {
    let title: String
    let description: String
    let dueDate: Date
}
