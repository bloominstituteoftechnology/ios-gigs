//
//  NetworkErrors.swift
//  Gigs
//
//  Created by Chris Gonzales on 2/13/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation

struct Errors{
    
    enum networkErrors: Error{
        case otherError
        case badData
        case badAuth
        case noDecode
        case networkError
        case noEncode
    }
}
