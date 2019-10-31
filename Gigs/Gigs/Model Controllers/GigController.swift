//
//  GigController.swift
//  Gigs
//
//  Created by Jon Bash on 2019-10-30.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import Foundation

class GigController {
    var gigs: [Gig] = []
    
    var apiController: APIController
    
    init(with apiController: APIController) {
        self.apiController = apiController
    }
    
    func getGigs() {
        apiController.fetchAllGigs { (result) in
            do {
                self.gigs = try result.get()
            } catch {
                if let error = error as? NetworkError {
                    print(error.rawValue)
                }
            }
        }
    }
}
