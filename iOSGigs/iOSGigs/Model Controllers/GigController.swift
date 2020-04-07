//
//  GigController.swift
//  iOSGigs
//
//  Created by Hunter Oppel on 4/7/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import Foundation

final class GigController {
    
    // MARK: Properties
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    enum NetworkError: Error {
        case failedSignUp, failedLogIn, noData, badData
    }
    
    static var bearer: Bearer?
    
    private let baseURL: URL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    private lazy var signUpURL: URL = baseURL.appendingPathComponent("/users/signup")
    private lazy var logInURL: URL = baseURL.appendingPathComponent("/users/login")
    
    private lazy var jsonEncoder = JSONEncoder()
    private lazy var jsonDecoder = JSONDecoder()
    
    // MARK: - Sign up/Log in
    
    func signUp(for user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        var request = postRequest(with: signUpURL)
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("Sign up failed with error: \(error.localizedDescription)")
                    return completion(.failure(.failedSignUp))
                }
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("Sign up was unsuccessful.")
                        return completion(.failure(.failedSignUp))
                }
                
                completion(.success(true))
            }
            .resume()
        } catch {
            print("Error encoding user: \(error.localizedDescription)")
            completion(.failure(.failedSignUp))
        }
    }
    
    func logIn(for user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        var request = postRequest(with: logInURL)
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Log in failed with error: \(error.localizedDescription)")
                    return
                }
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200
                    else {
                        print("Log in was unsuccessful.")
                        return completion(.failure(.failedLogIn))
                }
                guard let data = data else {
                    print("No data was returned.")
                    return completion(.failure(.noData))
                }
                
                do {
                    Self.bearer = try self.jsonDecoder.decode(Bearer.self, from: data)
                    completion(.success(true))
                } catch {
                    print("Error decoding bearer: \(error.localizedDescription)")
                    completion(.failure(.failedLogIn))
                }
            }
            .resume()
        } catch {
            print("Error encoding user: \(error.localizedDescription)")
            completion(.failure(.failedLogIn))
        }
    }
    
    private func postRequest(with url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
