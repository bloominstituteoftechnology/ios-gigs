//
//  GigController.swift
//  Gigs
//
//  Created by Bobby Keffury on 9/10/19.
//  Copyright © 2019 Bobby Keffury. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class GigController {
    
    
    
    private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    var bearer: Bearer?
    
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        let signUpUrl = baseURL.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpUrl)
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
    
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
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
    
    
    
    
    
    func logIn(with user: User, completion: @escaping (Error?) -> Void) {
        let logInUrl = baseURL.appendingPathComponent("users/login")
        
        var request = URLRequest(url: logInUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        
        do{
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
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
            
            let jsonDecoder = JSONDecoder()
            
            do {
                self.bearer = try jsonDecoder.decode(Bearer.self, from: data)
                
            } catch {
                print("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
         
            completion(nil)
        }.resume()

    }
}
