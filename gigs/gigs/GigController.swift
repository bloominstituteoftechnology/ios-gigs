//
//  GigController.swift
//  gigs
//
//  Created by Harm on 5/5/23.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
enum NetworkError: Error {
    case noData, failedSignUp
}

class GigController {
    
    var bearer: Bearer?
    
    private let baseURL: URL = URL(string: "https://nap-1-2-project-gigs-default-rtdb.firebaseio.com/.json")!
//    private lazy var signUpURL = baseURL.appendingPathComponent("/users/signup")
//    private lazy var signInURL = baseURL.appendingPathComponent("/users/login")
    
    private lazy var jsonEncoder = JSONEncoder()
    
    func signUp(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        var request = URLRequest(url: baseURL)//signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue//get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("Sign up failed with \(error)")
                    completion(.failure(.failedSignUp))
                    return
                }
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
        
    }
    
}
