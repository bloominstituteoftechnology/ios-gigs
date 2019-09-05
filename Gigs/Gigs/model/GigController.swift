//
//  GigController.swift
//  Gigs
//
//  Created by brian vilchez on 9/4/19.
//  Copyright © 2019 brian vilchez. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case encodingError
    case responseError
    case otherError
    case noData
    case noDecode
}

class GigController {
    
    var bearer: Bearer?
    var baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    func signUp(with user: User, completion: @escaping(NetworkError?) ->Void) {
        
        //adding paths to the api address
        var signUpURL = baseURL
        signUpURL.appendPathComponent("users")
        signUpURL.appendPathComponent("signup")
        
        // creating a post request.
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // parsing user into JSON
        let encoder = JSONEncoder()
        do {
            let userData = try encoder.encode(user)
            request.httpBody = userData
            
        } catch {
            NSLog("error encoding user: \(error)")
            completion(.encodingError)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data,response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.responseError)
                return
            }
            if let error = error {
                NSLog("Error creating user on server: \(error)")
                completion(.otherError)
                return
            }
            completion(nil)
        }.resume()
        
    }
    
    
    func login(with user: User, completion: @escaping(NetworkError?)->Void) {
        let loginURL = baseURL
        .appendingPathComponent("users")
        .appendingPathComponent("login")
        
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post.rawValue
         request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        
        do {
            request.httpBody = try encoder.encode(user)
        } catch {
            NSLog("error encoding user: \(error)")
            completion(.encodingError)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data,response,error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.responseError)
                return
            }
            if let error = error {
                NSLog("error loggin user in: \(error)")
            }

            guard let data = data else {
                completion(.noData)
                return
            }
            do {
                let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                self.bearer = bearer
            } catch {
                completion(.noDecode)
                return
            }
            completion(nil)
        }.resume()
        
    }
    
}


