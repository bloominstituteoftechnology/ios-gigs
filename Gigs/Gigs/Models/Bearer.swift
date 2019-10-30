//
//  Bearer.swift
//  Gigs
//
//  Created by Lambda_School_Loaner_204 on 10/30/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct Bearer: Codable {
    let id: Int
    let token: String
    let userId: Int
}
