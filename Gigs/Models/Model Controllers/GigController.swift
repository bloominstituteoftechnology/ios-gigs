//
//  GigController.swift
//  Gigs
//
//  Created by Eoin Lavery on 11/09/2019.s
//  Copyright © 2019 Eoin Lavery. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class GigController {
    
    //Bearer and baseURL variables to hold bearer token data and URl for API respectively.
    var bearer: Bearer?
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")
    
    //Function to Sign Up a new user.
    func signUp(for user: User, completion: @escaping (Error?) -> Void) {
        
        //Complete full API URL for Sign Up Function
        guard let baseURL = baseURL else { return }
        let signUpURL = baseURL.appendingPathComponent("/users/signup")
        
        //Create new HTTPRequest to handle Sign Up
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //Create JSONEncoder to prepare text for being wrapped and sent to API.
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding User object whilst creating an account: \(error)")
            completion(error)
            return
        }
        
        //URLSession Data Task to handle execution and return of data fron API web server.
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
    
    //Function to handle a existing user signing into their account.
    func signIn(for user: User, completion: @escaping (Error?) -> Void) {
        //Complete full API URL to allow existing users to sign in.
        guard let baseURL = baseURL else { return }
        let signInURL = baseURL.appendingPathComponent("/users/login")
        
        //Create a new HTTPRequest to handle Sign In
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //Create JSON Encoder property to handle encoding of data sent to the API.
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding User object whilst attempting to Sign In: \(error)")
            completion(error)
            return
        }
        
        //Create URLSession to handle communication to the API.
        URLSession.shared.dataTask(with: request) { data, response, error in
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
            
            let jsonDecoder = JSONDecoder()
            do {
                self.bearer = try jsonDecoder.decode(Bearer.self, from: data)
            } catch {
                print("Error decoding bearer object from JSON data: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            
        }.resume()
    }
    
}
