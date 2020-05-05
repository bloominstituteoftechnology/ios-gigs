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
    
    func signUp(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        print("singUpURL = \(signUpURL?.absoluteString)") // debug step to confirm correct URL
        
        var request = URLRequest(url: signUpURL!)
        request.httpMethod = HTTPMethod.post.rawValue
        //set up header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //take user object and convert it into JSON
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
            
            if let error = error {
                print("Sign up failed with error: \(error)")
                completion(.failure(.failedSignUp))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                    print("Sign up has failed")
                    completion(.failure(.failedSignUp))
                    return
            }
            completion(.success(true))
        }
        task.resume()
        } catch {
            print("Error encoding user: \(error)")
            completion(.failure(.failedSignUp))
        }
    }
}
