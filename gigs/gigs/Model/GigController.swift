//
//  GigController.swift
//  gigs
//
//  Created by ronald huston jr on 5/5/20.
//  Copyright © 2020 HenryQuante. All rights reserved.
//

import Foundation

final class GigController {
    
    //  MARK: - properties
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum NetworkError: Error {
        case failedSignUp, failedLogIn, noData, badData
    }
    
    var bearer: Bearer?
    
    private var baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    private lazy var signUpURL: URL = baseURL.appendingPathComponent("/users/signup")
    private lazy var logInURL: URL = baseURL.appendingPathComponent("/users/login")
    
    private lazy var jsonEncoder = JSONEncoder()
    private lazy var jsonDecoder = JSONDecoder()
    
    private let contentValue = "application/json"
    private let httpHeaderType = "Content-Type"
    
    // MARK: - sign up
    func signUp(for user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("sign up failed with error: /(error)")
                    completion(.failure(.failedSignUp))
                    return
                }
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("sign up was not successful.")
                        completion(.failure(.failedSignUp))
                        return
                }
                completion(.success(true))
            }
        .resume()

        } catch {
            print("error encoding user: \(error)")
            completion(.failure(.failedSignUp))
        }
    }
    
    func logIn(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        var request = URLRequest(url: logInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("catch error decoding the data into the error token")
            completion(.failure(.badData))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("log in failed with error: \(error)")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200
                else {
                    print("log in was not successful.");
                    completion(.failure(.failedLogIn))
                    return
            }
            
            guard let data = data else {
                print("no data was returned.")
                completion(.failure(.noData))
                return
            }
            
            do {
                self.bearer = try self.jsonDecoder.decode(Bearer.self, from: data)
                completion(.success(true))
                return
            } catch {
                print("error decoding bearer: \(error)")
                completion(.failure(.failedLogIn))
                return
            }
            
        }.resume()
    }
}
