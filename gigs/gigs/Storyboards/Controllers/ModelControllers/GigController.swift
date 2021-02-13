//
//  GigController.swift
//  gigs
//
//  Created by James McDougall on 2/11/21.
//

import Foundation
import UIKit

class GigController {
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case update = "UPDATE"
        case delete = "DELETE"
    }
    
    enum NetworkError: Error {
        case noData
        case noToken
        case noResponse
        case failedSignUp
        case failedLogIn
    }
    
    var bearer: Bearer?
    private lazy var baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    private lazy var signUpURL = baseURL.appendingPathComponent("/users/signup")
    private lazy var logInURL = baseURL.appendingPathComponent("/users/login")
    private lazy var jsonEncoder = JSONEncoder()
    private lazy var jsonDecoder = JSONDecoder()
    
    func signUp(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> ()) {
        print("SignUpURL = \(signUpURL)")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
                if let error = error {
                    print("Error signing user up for account: \(error)")
                    completion(.failure(.failedSignUp))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    print("Error getting a response from the server")
                    completion(.failure(.noResponse))
                    return
                }
                
                completion(.success(true))
            }
            task.resume()
        } catch {
            print("Error making a request to the server: \(error)")
            completion(.failure(.failedSignUp))
            return
        }
        
    }
    
}
