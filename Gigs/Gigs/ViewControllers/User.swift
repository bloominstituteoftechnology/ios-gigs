//
//  User.swift
//  Gigs
//
//  Created by Marissa Gonzales on 5/5/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
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
