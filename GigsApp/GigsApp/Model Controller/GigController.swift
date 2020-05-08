//
//  GigController.swift
//  GigsApp
//
//  Created by Clayton Watkins on 5/8/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import Foundation

class GigController {
    
    //MARK: - Properties
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum NetworkError: Error{
        case noData
        case noToken
        case failedSignUp
        case failedSignIn
    }
    
    var bearer: Bearer?
    private let baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    private lazy var signUpUrl = baseURL.appendingPathComponent("/users/signup")
    private lazy var signInUrl = baseURL.appendingPathComponent("/users/login")
    
    //MARK: - Functions
    func signUp(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        var request = postRequest(for: signInUrl)
        
        do{
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(user)
            print(String(data: jsonData, encoding: .utf8)!)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
                if let error = error {
                    print("Sign up failed with error: \(error)")
                    completion(.failure(.failedSignUp))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("Sign up was unsucessful")
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
    
    
    
    //MARK: - Helper Functions
    private func postRequest(for url: URL) -> URLRequest{
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("applicaiton/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
