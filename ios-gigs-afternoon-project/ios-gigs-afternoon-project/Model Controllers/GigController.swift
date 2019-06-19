//
//  GigController.swift
//  ios-gigs-afternoon-project
//
//  Created by Alex Shillingford on 6/19/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import Foundation
// MARK: - HTTPMethod Enumeration
enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}
// MARK: - GigController Class
class GigController {
    
    // MARK: - Properties
    var bearer: Bearer?
    private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    //MARK: - Methods and Functions
    func signUp(user: User, completion: @escaping (Error?) -> ()) {
        let signUpURL = baseURL.appendingPathComponent("/users/signup")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding User Object: \(error)")
            completion(error)
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    } // Closing brace for signUp() method
    
    func signIn(user: User, completion: @escaping (Error?) -> ()) {
        let signInURL = baseURL.appendingPathComponent("/users/login")
        
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding User Object: \(error)")
            completion(error)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            do {
                let decoder = JSONDecoder()
                self.bearer = try decoder.decode(Bearer.self, from: data)
            } catch {
                print("Error decoding: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            }.resume()
    }
}
