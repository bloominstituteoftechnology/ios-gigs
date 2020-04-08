//
//  GigController.swift
//  ios-gigs
//
//  Created by Shawn James on 4/7/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import Foundation

//This class will be responsible for signing you up, and logging you in for today then additionally creating gigs, and fetching gigs tomorrow.
class GigController {
    var bearer = Bearer?
    let baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")
}
