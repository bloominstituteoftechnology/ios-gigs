//
//  GigController.swift
//  Gigs
//
//  Created by John Kouris on 9/9/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class GigController {
    
    private let baseUrl = URL(string: "https://lambdagigs.vapor.cloud/api")
    var bearer: Bearer?
    
}
