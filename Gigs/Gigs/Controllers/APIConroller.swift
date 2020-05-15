//
//  File.swift
//  Gigs
//
//  Created by Clean Mac on 5/14/20.
//  Copyright © 2020 LambdaStudent. All rights reserved.
//

import Foundation
import UIKit

final class APIController {
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "Post"
    }
    
    enum NetworkError: Error {
        case noData, failedSignUp, failedSignIn, noToken
    }
    
    private let baseURL = URL(string: "http://lambdagigapi.herokuapp.com/api")!
    private lazy var signUpURL = baseURL.appendingPathComponent("/users/signup")
    private lazy var signInURL = baseURL.appendingPathComponent("/users/login")
    var bearer: Bearer?
    
    // SignUp
    
    func signUp(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        print("signUpURL = \(signUpURL.absoluteString)")
        
        var request = postRequest(for: signUpURL)
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(user)
            print(String(data: jsonData, encoding: .utf8)!)
            request.httpBody = jsonData
            
            
            
            let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
                if let error = error {
                    print ("signup failed with error: \(error)")
                    completion(.failure(.failedSignUp))
                    return
                    
                }
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("sign up was unsuccessful")
                        completion(.failure(.failedSignUp))
                        return
                }
                completion(.success(true))
            }
            task.resume()
        } catch {
            print("error encoding user: \(error)")
            completion(.failure(.failedSignUp))
        }
        
    }
    
    // SignIn
    func signIn(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        var request = postRequest(for: signInURL)
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(user)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("sign ing error: \(error)")
                    completion(.failure(.failedSignIn))
                    return
                }
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("Sign in Failed")
                        completion(.failure(.failedSignIn))
                        return
                }
                
                guard let data = data else {
                    print("Data not received")
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    self.bearer = try decoder.decode(Bearer.self, from: data)
                    completion(.success(true))
                } catch {
                    print("error decoding bearer: \(error)")
                    completion(.failure(.noToken))
                    return
                }
                } .resume()
        } catch {
            print("error encodig user: \(error.localizedDescription)")
            completion(.failure(.failedSignIn))
        }
        
    }
    private func postRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
