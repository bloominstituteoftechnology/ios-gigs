//
//  AuthenticationController.swift
//  Gigs
//
//  Created by Chad Rutherford on 12/4/19.
//  Copyright © 2019 lambdaschool.com. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class AuthenticationController {
    
    var bearer: Bearer?
    
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")
    
    /// Sign Up : /users/signup
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        guard let url = baseURL else { return }
        let signInURL = url.appendingPathComponent("users/signup")
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(user)
            request.httpBody = data
        } catch let encodeError {
            print("Error encoding User objcet: \(encodeError.localizedDescription)")
            completion(encodeError)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
    /// Log In: /users/login
    func logIn(with user: User, completion: @escaping (Error?) -> ()) {
        
    }
}
