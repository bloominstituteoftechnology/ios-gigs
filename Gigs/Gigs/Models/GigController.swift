//
//  GigController.swift
//  Gigs
//
//  Created by scott harris on 2/12/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum HTTPHeaderValue: String {
    case json = "application/json"
}

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
}

class GigController {
    var bearer: Bearer?
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        let signUpURL = baseURL.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(HTTPHeaderValue.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(user)
            request.httpBody = data
        } catch {
            NSLog("Error encoding user object \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                NSLog("Error recieved From Data Task \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                    completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                    return
            }
            
            completion(nil)
            
        }.resume()
        
    }
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        let signUpURL = baseURL.appendingPathComponent("users/login")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(HTTPHeaderValue.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(user)
            request.httpBody = data
        } catch {
            NSLog("Error encoding user object \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error recieved From Data Task \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
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
                NSLog("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            
            
        }.resume()
        
        
    }
    
}
