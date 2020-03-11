//
//  User.swift
//  Gigs
//
//  Created by Eoin Lavery on 11/09/2019.
//  Copyright © 2019 Eoin Lavery. All rights reserved.
//

import Foundation

//User struct to create JSON file to login with API.
struct User: Codable {
    let username: String
    let password: String
}
