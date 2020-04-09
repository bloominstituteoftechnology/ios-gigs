//
//  GigViewModel.swift
//  GigsApp
//
//  Created by Bhawnish Kumar on 4/8/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation
final class GigViewModel {
    enum GetGigsNamesResult {
        case success
        case failure(String)
        
    }
    var gigNames = [Gig]()
    var shouldPresentLoginViewController: Bool {
        GigController.bearer == nil
    }
    
    private let gigController: GigController
    
    init(gigController: GigController = GigController()) {
        self.gigController = gigController
    }
    
    func getGigsNames(completion: @escaping (GetGigsNamesResult) -> Void) {
        
    }
}
