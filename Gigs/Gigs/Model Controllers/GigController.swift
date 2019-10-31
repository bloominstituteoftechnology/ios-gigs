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
    
    func fetchGigsFromNetwork() {
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
    
    func create(gig: Gig, completion creationSuccessful: @escaping (Bool) -> ()) {
        if gigs.contains(where: { $0.title == gig.title }) {
            print("Error attempting to save duplicate gig: gig already exists.")
            creationSuccessful(false)
            return
        }
        
        apiController.postNew(gig: gig) { result in
            do {
                let postedGig = try result.get()
                self.gigs.append(postedGig)
                creationSuccessful(true)
            } catch {
                if let error = error as? NetworkError {
                    print(error.rawValue)
                }
                creationSuccessful(false)
            }
        }
    }
}
