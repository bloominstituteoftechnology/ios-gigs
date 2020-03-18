//
//  GigController.swift
//  Gigs
//
//  Created by Claudia Contreras on 3/17/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class GigController {
    var bearer: Bearer?
    
    private let baseURL =  URL(string: "https://lambdagigapi.herokuapp.com/api")!
    
    // MARK: - Functions
    
    // Create function for sign up
    func signUp(with user: User, completion: @escaping (Error?) -> Void ) {
        let signUpURL = baseURL.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encoder
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Erro encoding user object: \(error)")
            completion(error)
            return
        }
        
        // Get the response
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
            
            // If everything works out
            completion(nil)
        }.resume()
    }
    
    // Create a function for Logging In
    func logIn(with user: User, completion: @escaping (Error?) -> Void) {
        let loginURL = baseURL.appendingPathComponent("/users/login")
        
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //Encode
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        //Request data
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
            
            // Decode the data
            let decoder = JSONDecoder()
            do {
                self.bearer = try decoder.decode(Bearer.self, from: data)
                completion(nil)
            } catch {
                print("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            
            // If we succeed
            completion(nil)
            
        }.resume()
    }
}
