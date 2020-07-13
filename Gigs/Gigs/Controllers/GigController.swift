//
//  GigController.swift
//  Gigs
//
//  Created by Eoin Lavery on 13/07/2020.
//  Copyright © 2020 Eoin Lavery. All rights reserved.
//

import Foundation

class GigController {
    var bearer: Bearer?
    var baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")
    
    func signup(user: User, completion: @escaping (Error?) -> Void) {
        
        guard let url = baseURL?.appendingPathComponent("/users/signup") else {
            print("Supplied URL is invalid.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding User object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(error)
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func signin(user: User, completion: @escaping (Error?) -> Void) {
        
        guard let url = baseURL?.appendingPathComponent("users/login") else {
            print("Supplied URL is invalid.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding User object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(nil)
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(error)
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                self.bearer = try jsonDecoder.decode(Bearer.self, from: data)
            } catch {
                print("Error decoding Bearer object from JSON: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
        
    }
    
}
