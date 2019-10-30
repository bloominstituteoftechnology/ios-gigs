//
//  GigController.swift
//  ios gigs
//
//  Created by Thomas Sabino-Benowitz on 10/30/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class GigController {
    
    private let baseUrl = URL(string: " https://lambdagigs.vapor.cloud/api")!
     
     var bearer: Bearer?
    
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        let signUpURL = baseUrl.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpURL)
         request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do{
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("ERROR encoding user object: \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { _, response, error in
            
          if let response = response as? HTTPURLResponse,
            response.statusCode != 200 {
            completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
            return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
}
