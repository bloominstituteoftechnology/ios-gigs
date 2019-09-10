//
//  Bearer.swift
//  Gigs
//
//  Created by Fabiola S on 9/10/19.
//  Copyright © 2019 Fabiola Saga. All rights reserved.
//

import Foundation

struct Bearer: Codable {
    let id: Int
    let token: String
    let userId: Int
}
