//
//  Bearer.swift
//  Gigs
//
//  Created by Eoin Lavery on 11/09/2019.
//  Copyright © 2019 Eoin Lavery. All rights reserved.
//

import Foundation

//Bearer struct to collect and organise data returned from JSON via API
struct Bearer: Codable {
    //let id: Int
    let token: String
    //let userId: Int
}
