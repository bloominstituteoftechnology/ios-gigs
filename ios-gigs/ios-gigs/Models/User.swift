//
//  User.swift
//  ios-gigs
//
//  Created by Aaron on 9/10/19.
//  Copyright © 2019 AlphaGrade, INC. All rights reserved.
//

import Foundation

struct User: Codable {
    
    let username: String
    let password: String

}

enum Status {
    case signUp
    case signIn
}
