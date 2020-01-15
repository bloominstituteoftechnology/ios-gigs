//
//  Bearer.swift
//  gigs
//
//  Created by Kenny on 1/15/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

enum LoginType: String {
    case signIn
    case signUp
}
struct Bearer: Codable {
    let token: String
}
