//
//  bearer.swift
//  gigsCraigBelinfante
//
//  Created by Craig Belinfante on 7/12/20.
//  Copyright © 2020 Craig Belinfante. All rights reserved.
//

import Foundation

struct Bearer: Codable {
    let token: String
    let id: Int
    let userId: Int
}
