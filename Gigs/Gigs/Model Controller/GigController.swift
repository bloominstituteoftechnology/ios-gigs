//
//  GigController.swift
//  Gigs
//
//  Created by Sammy Alvarado on 7/11/20.
//  Copyright © 2020 Sammy Alvarado. All rights reserved.
//

import Foundation

class GigiController {

    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }

    private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")
    private lazy var signUpURL = baseURL?.appendingPathComponent("/users/signup")
    private lazy var signInURL = baseURL?.appendingPathComponent("/users/login")
    var bearer: Bearer?


    private func postRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }


}
