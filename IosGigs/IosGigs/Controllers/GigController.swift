//
//  GigController.swift
//  IosGigs
//
//  Created by Kelson Hartle on 5/5/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import Foundation
import UIKit

final class GigController {
    
    // MARK: - Enumerations
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    enum NetworkError: Error {
        case noData, failedSignUP
    }
    
    // MARK: - Properties
    
    var bearer: Bearer?
    
    private let baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    private lazy var signUpURL = baseURL.appendingPathComponent("users/signup")
    private lazy var signInURL = baseURL.appendingPathComponent("users/login")
    private lazy var jsonEncoder = JSONEncoder()
    
    // MARK: - Functions
    
    func signUP(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        print("signUpUrl = \(signUpURL.absoluteString)")
        
        var request = URLRequest(url: signUpURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
                if let error = error {
                    print("Sign up failed with error: \(error)")
                    completion(.failure(.failedSignUP))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("Sign up has failed")
                        completion(.failure(.failedSignUP))
                        return
                }
                
                completion(.success(true))
            }
            task.resume()
            
        } catch {
            print("Error encoding user: \(error)")
            completion(.failure(.failedSignUP))
        }
    }
}
