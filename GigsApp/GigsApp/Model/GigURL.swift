//
//  GigURL.swift
//  GigsApp
//
//  Created by Bhawnish Kumar on 4/7/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation

struct GigUrl {
   
    let baseURL: URL = {
        URL(string: "https://lambdagigapi.herokuapp.com/api")!
    }()
}
