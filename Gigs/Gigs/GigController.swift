//
//  GigController.swift
//  Gigs
//
//  Created by David Williams on 3/17/20.
//  Copyright © 2020 david williams. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
class GigController {
    
     var bearer : Bearer?
    
    private let baseUrl = URL(string: "https://lambdagigapi.herokuapp.com/api")!
}
