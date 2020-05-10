//
//  GigController.swift
//  Gigs
//
//  Created by Josh Kocsis on 5/8/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import Foundation
import UIKit

class GigController {
    
    var bearer: Bearer?
    let baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    lazy var signUpURL = baseURL.appendingPathComponent("/users/signup")
    lazy var signInURL = baseURL.appendingPathComponent("/users/login")
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }

    enum NetworkError: Error {
        case noData, failedSignUp, failedSignIn, noToken
    }
    
    private func postRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func signUp(with user: User, completion: @escaping(Result<Bool, NetworkError>) -> Void) {
        print("signUpURL = \(signUpURL.absoluteString)")
        
        var request = postRequest(for: signUpURL)
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(user)
            print(String(data: jsonData, encoding: .utf8)!)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
                // Check for error first
                if let error = error {
                    print("Sign up failed with error: \(error)")
                    completion(.failure(.failedSignUp))
                    return
                }
                
                // Check for response and make sure it is a 200
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("Sign up was unsuccessful")
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
    
    func signIn(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        var request = postRequest(for: signInURL)
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(user)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Sign in failed with error: \(error)")
                    completion(.failure(.failedSignIn))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("Sign in was Unsuccessful.")
                        completion(.failure(.failedSignIn))
                        return
                }
                
                guard let data = data else {
                    print("Data was not recieved.")
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    self.bearer = try decoder.decode(Bearer.self, from: data)
                    completion(.success(true))
                } catch {
                    print("Error decoding Bearer: \(error)")
                    completion(.failure(.noToken))
                    return
                }
            }
            task.resume()
        } catch {
            print("Error encoding user: \(error)")
            completion(.failure(.failedSignIn))
        }
    }
    
}
