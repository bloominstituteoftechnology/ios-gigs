//
//  APIController.swift
//  gigsCraigBelinfante
//
//  Created by Craig Belinfante on 7/12/20.
//  Copyright © 2020 Craig Belinfante. All rights reserved.
//

import Foundation
import UIKit

final class APIController {
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum NetworkError: Error {
        case noData
        case failedSignUp
        case failedSignIn
        case noToken
    }
    
    var bearer: Bearer?
    
    private let baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
  //add users
    private lazy var signUpURL = baseURL.appendingPathComponent("/users/signup")
  //add logins
    private lazy var signInURL = baseURL.appendingPathComponent("/users/login")
    
    
    
    // create function for sign up
    func signUp(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
       print("signUpUrl = \(signUpURL.absoluteString)")
        
        var request = postRequest(for: signUpURL)
        
        do {
            let jsonData = try JSONEncoder().encode(user)
            print(String(data:jsonData, encoding: .utf8)!)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) {  (_, response, error) in
                if let error = error {
                    print("Sign up failed with error: \(error)")
                    completion(.failure(.failedSignUp))
                    return
                }
                
                //Handle response check to make sure its the same
                
                guard let response = response as? HTTPURLResponse,
                    response.statusCode==200 else {
                 print("Sign up was bitchin")
                        completion(.failure(.failedSignUp))
                        return
                }
                
                completion(.success(true))
                
            }
            task.resume()
        } catch {
            // associates with our try
            //catches error
            print("Error encoding user: \(error)")
            completion(.failure(.failedSignUp))
        }
    }
    
    //Helper method
    private func postRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    
    // create function for sign in
    func signIn(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        var request = postRequest(for: signInURL)
        
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Sign in failed with error: \(error)")
                    completion(.failure(.failedSignIn))
                    return
                }
                guard let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                    print("Sign in was successful")
                    completion(.failure(.failedSignIn))
                    return
                }
                
                guard let data = data else {
                    print("No data")
                    completion(.failure(.failedSignIn))
                    return
                }
                
                do {
                    self.bearer = try JSONDecoder().decode(Bearer.self, from: data)
                    completion(.success(true))
                    
                } catch {
                    print("Error decoding bearer: \(error)")
                    completion(.failure(.noToken))
                }
            }
            task.resume()
        } catch {
            print("Error encoding user: \(error.localizedDescription)")
            completion(.failure(.failedSignIn))
        }
        
    }
}
