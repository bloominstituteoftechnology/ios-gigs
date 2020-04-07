//
//  GigController.swift
//  GigsApp
//
//  Created by Bhawnish Kumar on 4/7/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation

final class GigController {
    
    enum HTTPMethod: String {
          case get = "GET"
          case post = "POST"
      }
      enum NetworkError: Error {
          case failedSignUp, failedSignIn, noData, badData
      }
    
    private static var gigUrl: GigUrl?
    static var bearer: Bearer?
    
    private var baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    
    
    
    private func postRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
