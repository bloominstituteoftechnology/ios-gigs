//
//  GigController.swift
//  gigs
//
//  Created by Waseem Idelbi on 3/17/20.
//  Copyright © 2020 WaseemID. All rights reserved.
//

import Foundation

class GigController {
    
    //MARK: -Properties-
    
    var bearer: Bearer?
    let baseURL: URL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    
    //MARK: -Methods-
    
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        
        let signUpURL = baseURL.appendingPathComponent("users/signup")
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            let userData = try encoder.encode(user)
            request.httpBody = userData
        } catch {
            print("Error encoding the user object \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            guard error == nil else {
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
        
    } //End of sign up function
    
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        
        let signInURL = baseURL.appendingPathComponent("/users/login")
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            let userData = try encoder.encode(user)
            request.httpBody = userData
        } catch {
            print("Error encoding the user object \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
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
                print("Error decoding the bearer object: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
        
    } //End of sign in function
    
    
} //End of class
