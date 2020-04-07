//
//  User.swift
//  Gigs Project
//
//  Created by Mark Poggi on 4/7/20.
//  Copyright © 2020 Mark Poggi. All rights reserved.
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
