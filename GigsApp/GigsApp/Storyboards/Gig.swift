//
//  Gig.swift
//  GigsApp
//
//  Created by Bhawnish Kumar on 4/8/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation

struct Gig: Decodable, Hashable {
    let title: String
    let description: String
    let dueDate: Date
}
