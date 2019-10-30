//
//  APIController.swift
//  Gigs
//
//  Created by Jon Bash on 2019-10-30.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import Foundation

enum AuthType: String {
    case signUp = "Sign up"
    case logIn = "Log in"
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

fileprivate let callComponents: [AuthType: (
    url: String,
    httpMethod: HTTPMethod
    )] = [
        .signUp: (
            url: "/users/signup",
            httpMethod: .post
        ),
        .logIn: (
            url: "/users/login",
            httpMethod: .post
        )
]

class APIController {
    var bearer: Bearer?
    let baseURL: URL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    func handleCall(_ callType: AuthType, with user: User, completion: @escaping (Error?) -> Void) {
        let call = callComponents[callType]
        
        let authURLComponent = call?.url ?? "/users/login"
        let authURL = baseURL.appendingPathComponent(authURLComponent)
        
        var request = URLRequest(url: authURL)
        request.httpMethod = call?.httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            if callType == .logIn {
                guard let data = data else {
                    completion(NSError())
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    self.bearer = try decoder.decode(Bearer.self, from: data)
                } catch {
                    completion(error)
                    return
                }
            }
            
            completion(nil)
        }.resume()
    }
    
    /*
    // create function for sign up
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        let signUpURL = baseURL.appendingPathComponent("users/signup")
        
        var request = URLRequest(url:signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
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
    }
    
    // create function for sign in
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        let signInURL = baseURL.appendingPathComponent("users/login")
        
        var request = URLRequest(url:signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200
            {
                completion(NSError(
                    domain: "",
                    code: response.statusCode,
                    userInfo: nil
                ))
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
            let decoder = JSONDecoder()
            do {
                self.bearer = try decoder.decode(Bearer.self, from: data)
            } catch {
                print("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
 */
}
