//
//  gig+enums.swift
//  gigs
//
//  Created by Hector Steven on 5/9/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
}

enum NetworkError: Error {
	case noAuth
	case badAuth
	case otherError
	case badData
	case noDecode
}

enum LoginType {
	case SignUp
	case SignIn
}
