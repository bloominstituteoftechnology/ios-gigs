//
//  Bearer.swift
//  gigs
//
//  Created by Harm on 5/5/23.
//

import Foundation

struct Bearer: Codable {
    
    var id: Int = Int.random(in: 1...5000)
    var token: String //= UUID().uuidString
    var userId: Int = Int.random(in: 1...5000)
    
}
