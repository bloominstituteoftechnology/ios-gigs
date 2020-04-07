//
//  GigController.swift
//  GigsApp
//
//  Created by Bhawnish Kumar on 4/7/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation

final class GigController {
    
    private static var gigUrl: GigUrl?
    static var bearer: Bearer?
    
    private var baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    
    
}
