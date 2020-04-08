//
//  GigController.swift
//  GigsApp
//
//  Created by Bhawnish Kumar on 4/7/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation
import UIKit

class GigController {
//    MARK: ENUMS
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    enum NetworkError: Error {
        case failedSignUp, failedSignIn, noData, badData
    }
   
//    END
    
   static var bearer: Bearer?
    
    
    
    //    MARK: ENCODER
    let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    //    MARK: DECODER
    private lazy var jsonDecoder = JSONDecoder()
    
    //    MARK: BASEURL
    private let baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    private lazy var signUpUrl = baseURL.appendingPathComponent("/users/signup")
    private lazy var signInURL = baseURL.appendingPathComponent("/users/login")
    //    MARK: SIGNUP FUNCTION
    func signUp(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        var request = postRequest(for: signUpUrl)
        // MARK: Encoder
        let jsonEncoder: JSONEncoder = {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            return encoder
        }()
        do {
            let jsonData = try jsonEncoder.encode(user)
            print(String(data: jsonData, encoding: .utf8)!)
            request.httpBody = jsonData
            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("Error in signing up \(error.localizedDescription)")
                    completion(.failure(.failedSignUp))
                    return
                }
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200
                    else {
                        print("Unsuccessful Sign up")
                        return completion(.failure(.failedSignUp))
                        
                }
                completion(.success(true))
            }
            .resume()
        } catch {
            print("Error in signin up: \(error.localizedDescription)")
            completion(.failure(.failedSignUp))
            
        }
        
    }
    //    MARK: SIGNIN URL
    
        func signIn(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        var request = postRequest(for: signInURL)
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Sign in failed with error: \(error.localizedDescription)")
                    completion(.failure(.failedSignIn))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200
                    else {
                        print("Sign in was unsuccessful")
                        return completion(.failure(.failedSignIn))
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
                    completion(.failure(.failedSignIn))
                }
            }
            .resume()
        } catch {
            print("Error encoding user: \(error.localizedDescription)")
            completion(.failure(.failedSignIn))
        }
    }
    
    
    
    //    MARK: REQUEST URL METHOD USED IN SIGN UP AND SIGNED IN
   private func postRequest(for url: URL) -> URLRequest {
           var request = URLRequest(url: url)
           request.httpMethod = HTTPMethod.post.rawValue
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           return request
       }
    
    
}
