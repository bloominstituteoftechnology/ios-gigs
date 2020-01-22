//
//  GigController.swift
//  iOs-Gigs
//
//  Created by Sal Amer on 1/21/20.
//  Copyright © 2020 Sal Amer. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class GigController {

    let baseUrl = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    var bearer: Bearer?
    
     // create function for sign up
    //    func signUp(with user: User, completion: @escaping (Error?) -> ()) - () same as void
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        let signUpURL = baseUrl.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error Encoding user object: \(error)")
            completion(error)
            return
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
    }
       // create function for sign in
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        let signInURL = baseUrl.appendingPathComponent("users/login")
        
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error Encoding user object: \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { ( data, response, error) in
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
            
            let decoder = JSONDecoder()
            do {
                self.bearer = try decoder.decode(Bearer.self, from: data)
            } catch {
                print("Error Decoding bearer object: \(error)")
                completion(error)
                return
            }
                completion(nil)
            }.resume()
    }
    
    // create function for fetching all animal names
    
    // create function to fetch image
    
    
}
