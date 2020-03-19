//
//  Gig.swift
//  Gigs
//
//  Created by macbook on 10/3/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct Gig {
    var title: String
    var description: String
    var dueDate: Date
}


// TODO: - This date format in the JSON above is called "ISO 8601", which is another common format for dates. Luckily, when you get to decoding the JSON data, you can specify that you want dates to be decoded from this format using the .dateDecodingStrategy property on your JSONDecoder instance.  ( part 2  )
