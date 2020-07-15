//
//  Gig.swift
//  Gigs
//
//  Created by Cora Jacobson on 7/14/20.
//  Copyright © 2020 Cora Jacobson. All rights reserved.
//

import Foundation

struct Gig: Codable, Equatable {
    let title: String
    let dueDate: Date
    let description: String
}
