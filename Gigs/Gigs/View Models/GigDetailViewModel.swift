//
//  GigDetailViewModel.swift
//  Gigs
//
//  Created by Nichole Davidson on 4/8/20.
//  Copyright © 2020 Nichole Davidson. All rights reserved.
//

import Foundation
import UIKit

final class GigDetailViewModel {
    enum GetGigResult {
        case successfulWithGig(Gig)
        case failure(String)
    }
    
    private let gigController: GigController
    
    init(gigController: GigController = GigController()) {
        self.gigController = gigController
    }
    
    func getGig(with title: String, completion: @escaping (GetGigResult) -> Void) {
        gigController.getGig(for: title) { result in
            DispatchQueue.main.async {  // maybe need [ weak self ] in
                do {
                    let gig = try result.get()
                    completion(.successfulWithGig(gig))
                } catch {
                    completion(.failure("Unable to fetch gig: \(title)"))
                }
            }
        }
    }
}
