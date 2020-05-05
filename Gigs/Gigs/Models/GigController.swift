//
//  GigController.swift
//  Gigs
//
//  Created by Marissa Gonzales on 5/5/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//

import Foundation

class GigController {
    
    // HTTP method handling
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    // Error Handling
    enum NetworkError: Error {
        case noData, failedSignUp
    }
    
    var bearer: Bearer?
    
    private let baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")
    private lazy var signUpURL = baseURL?.appendingPathComponent("/users/signup")
    private lazy var signInUrl = baseURL?.appendingPathComponent("/users/login")
    private lazy var jsonEncoder = JSONEncoder()
    
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        print("singUpURL = \(signUpURL?.absoluteString ?? "")") // debug step to confirm correct URL
        
        var request = URLRequest(url: signUpURL!)
        request.httpMethod = HTTPMethod.post.rawValue
        //set up header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //take user object and convert it into JSON
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo:nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            let decoder = JSONDecoder()
            do {
                self.bearer = try decoder.decode(Bearer.self, from: data)
            } catch {
                print("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }
        .resume()
    }
}

