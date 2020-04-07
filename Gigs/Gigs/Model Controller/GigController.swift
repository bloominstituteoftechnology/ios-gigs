//
//  GigController.swift
//  Gigs
//
//  Created by Nichole Davidson on 4/7/20.
//  Copyright © 2020 Nichole Davidson. All rights reserved.
//

import Foundation
import UIKit

class GigController {
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum NetworkError: Error {
        case failedSignUp, failedLogin, noData, badData
    }
    
    static var bearer: Bearer?
    
    private let baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    private lazy var signUpURL = baseURL.appendingPathComponent("/users/signup")
    private lazy var loginURL = baseURL.appendingPathComponent("/users/login")
    
    private lazy var jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    
    private lazy var jsonDecoder = JSONDecoder()
    
    func signUp(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        var request = postRequest(for: signUpURL)
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            print(String(data: jsonData, encoding: .utf8)!)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("Sign up failed with error: \(error.localizedDescription)")
                    completion(.failure(.failedSignUp))
                }
                
                guard let response = response as? HTTPURLResponse,
                response.statusCode == 200
                    else {
                        print("Sign up was unseccessful")
                        completion(.failure(.failedSignUp))
                        return
                }
                
                completion(.success(true))
            }
            
            .resume()
        } catch {
            print("Error encoding user: \(error.localizedDescription)")
            completion(.failure(.failedSignUp))
            
        }
    }
    
    func login(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
           var request = postRequest(for: loginURL)
           
           do {
               let jsonData = try jsonEncoder.encode(user)
               request.httpBody = jsonData
               
               URLSession.shared.dataTask(with: request) { data, response, error in
                   if let error = error {
                       print("Sign in failed with error: \(error.localizedDescription)")
                       completion(.failure(.failedLogin))
                   }
                   
                   guard let response = response as? HTTPURLResponse,
                       response.statusCode == 200
                       else {
                           print("Sign in was unseccessful")
                           completion(.failure(.failedLogin))
                           return
                   }
                   
                   guard let data = data else {
                       print("Data was not received")
                       completion(.failure(.noData))
                       return
                   }
                   
                   do {
                    Self.bearer = try self.jsonDecoder.decode(Bearer.self, from: data)
                       completion(.success(true))
                   } catch {
                       print("Error decoding bearer: \(error.localizedDescription)")
                       completion(.failure(.failedLogin))
                   }
               }
               .resume()
           } catch {
               print("Error encoding user: \(error.localizedDescription)")
               completion(.failure(.failedLogin))
           }
       }
    
    private func postRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
}
