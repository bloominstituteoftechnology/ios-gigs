//
//  NetworkError.swift
//  Gigs
//
//  Created by Casualty on 9/12/19.
//  Copyright © 2019 Thomas Dye. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
}
