//
//  GigsController.swift
//  Gigs
//
//  Created by Norlan Tibanear on 7/11/20.
//  Copyright © 2020 Norlan Tibanear. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case noData
    case failedSignUp
    case failedSignIn
    case noToken
}


class GigsController {
    
    
    private let baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    private lazy var singUpURL = baseURL.appendingPathComponent("/users/signup")
    private lazy var signInURL = baseURL.appendingPathComponent("/users/login")
    
    var bearer: Bearer?
    var gigs: [Gig] = []
    
    
    // create function for sign up
        
        func signUp(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
            print("sigUpURL = \(signInURL.absoluteString)")
            
            var request = postRequest(for: singUpURL)
            
            
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let jsonData = try encoder.encode(user)
                print(String(data: jsonData, encoding: .utf8)!)
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
                    
                    // Check for error first
                    if let error = error {
                        print("Sing up failed with error: \(error)")
                        completion(.failure(.failedSignUp))
                        return
                    }
                    
                    // Check for response and make sure is a 200
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
            
        } //
        
        // create function for sign in
        func signIn(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
                
            var request = postRequest(for: signInURL)
            
            
            do {
                
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(user)
                request.httpBody = jsonData
                
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    
                    // Handle Error
                    if let error = error {
                        print("Sign in failed with error \(error)")
                        completion(.failure(.failedSignIn))
                        return
                    }
                    
                    // Handle Response
                    guard let response = response as? HTTPURLResponse,
                        response.statusCode == 200 else {
                            print("Sign In was unsuccessful")
                            completion(.failure(.failedSignIn))
                            return
                    }
                    
                    // Handle Data
                    guard let data = data else {
                        print("Data was not received")
                        completion(.failure(.noData))
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        self.bearer = try decoder.decode(Bearer.self, from: data)
                        completion(.success(true))
                    } catch {
                        print("Error decoding bearer: \(error)")
                        completion(.failure(.noToken))
                        return
                    }
                }.resume()
            } catch {
                print("Error encoding user: \(error)")
                completion(.failure(.failedSignIn))
            }
            
        } //
        
        // Helper to get the POST Request URL
        private func postRequest(for url: URL) -> URLRequest {
            
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            return request
            
        } //

    
    
    
    
} // CLASS
