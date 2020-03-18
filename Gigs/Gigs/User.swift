//
//  User.swift
//  Gigs
//
//  Created by Morgan Smith on 1/21/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import Foundation

struct User: Codable {
    
    init(username: String, password: String, userID: Int? = nil) {
        self.username = username
        self.password = password
    }
    
    let username: String
    let password: String
}
