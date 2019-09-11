//
//  Bearer.swift
//  Gigs
//
//  Created by Dillon P on 9/10/19.
//  Copyright © 2019 Lambda iOSPT2. All rights reserved.
//

import Foundation

struct Bearer: Codable {
    let id: String
    let token: String
    let userId: String
}
