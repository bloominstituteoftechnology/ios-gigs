//
//  GigController.swift
//  Gigs
//
//  Created by Nathan Hedgeman on 8/7/19.
//  Copyright © 2019 Nate Hedgeman. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "Delete"
    case put = "PUT"
}

enum NetworkError: Error {
    case noData
    case badAuth
    case noDecode
    case failedFetch(Error)
    case badURL
    case invalidData
    case failedSignUp(Error)
}

class GigController {
    
    //Properties
    var bearer: Bearer?
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
}


//LogIn & SignUp functions
extension GigController {
    
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        
        let appendedURL = baseURL.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: appendedURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            
            let data = try JSONEncoder().encode(user)
            request.httpBody = data
            
        } catch {
            
            NSLog("signUpGigController: Error encoding user info: \(error)")
            completion(error)
            return
            
        }
        
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NetworkError.failedSignUp(NSError(domain: "https://lambdagigs.vapor.cloud/api/users/signup", code: response.statusCode, userInfo: nil)))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
            
            }.resume()
    }
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        
        let appendedURL = baseURL.appendingPathComponent("users/login")
        
        var request = URLRequest(url: appendedURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            
            let data = try JSONEncoder().encode(user)
            request.httpBody = data
            
        } catch {
            
            NSLog("signInGigController: Error encoding user info: \(error)")
            completion(error)
            return
            
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NetworkError.failedSignUp(NSError(domain: "https://lambdagigs.vapor.cloud/api/users/signup", code: response.statusCode, userInfo: nil)))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else { completion(NetworkError.invalidData); return}
            
            do {
                
                self.bearer = try JSONDecoder().decode(Bearer.self, from: data)
                
            } catch {
                
                NSLog("signInGigController: Error decoding bearer token: \(error)")
                completion(NetworkError.noDecode)
                return
            }
            
            completion(nil)
            
        }.resume()
    }
    
}

//API interactivity functions
extension GigController {
    
    
    func getGigs() {
        
    }
}
