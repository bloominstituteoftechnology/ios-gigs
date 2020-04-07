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
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    enum NetworkError: Error {
        case failedSignUp, failedSignIn, noData, badData
    }
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
    
    //    MARK: SIGNUP FUNCTION
    func signUp(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        let signUpUrl = baseURL.appendingPathComponent("/users/signup")
        var request = postRequest(url: signUpUrl)
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
            }
        } catch {
            print("Error in signin up: \(error.localizedDescription)")
            completion(.failure(.failedSignUp))
            
        }
        
    }
    //    MARK: SIGNIN URL
    
    func signIn(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        let signInUrl = baseURL.appendingPathComponent("/users/login")
        let request = postRequest(url: signInUrl)
        
        do {
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error in signing in \(error.localizedDescription)")
                    completion(.failure(.failedSignIn))
                    return
                }
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200
                    else {
                        print("Unsucessful sign in")
                        return completion(.failure(.failedSignIn))
                }
                guard let data = data else  {
                    print("Error in signing \(String(describing: error?.localizedDescription))")
                    completion(.failure(.noData))
                    return
                }
            
            do {
                Self.bearer = try self.jsonDecoder.decode(Bearer.self, from: data)
                completion(.success(true))
            } catch {
                print("error decoded bearer: \(error.localizedDescription)")
                completion(.failure(.failedSignIn))
            }
            }
        } catch {
            
        }
        
        
    }
    
    
    
    //    MARK: REQUEST URL METHOD USED IN SIGN UP AND SIGNED IN
    private func postRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
}
