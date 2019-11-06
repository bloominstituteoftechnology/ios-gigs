//
//  NetworkError.swift
//  Gigs
//
//  Created by Jessie Ann Griffin on 9/12/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
    case noEncode
}
