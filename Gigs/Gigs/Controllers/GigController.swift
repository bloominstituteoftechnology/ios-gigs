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
    var gigs: [Gig] = []
    
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
    
    func getAllGigs(completion: @escaping (Error?) -> Void) {
        
        guard let bearer = bearer else {
            print("Error: No Valid Bearer token found!")
            completion(nil)
            return
        }
        
        guard let url = baseURL?.appendingPathComponent("/gigs") else {
            print("Error: URL Provided is not valid.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                completion(error)
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
            
            do {
                self.gigs = try jsonDecoder.decode([Gig].self, from: data)
                completion(nil)
            } catch {
                print("Error: Received data from server, but unable to decode into a valid format: \(error)")
                completion(error)
                return
            }
            
        }.resume()
    }
    
    func addNewGig(title: String, description: String, dueDate: Date, completion: @escaping (Error?) -> Void) {
        
        let newGig = Gig(title: title, description: description, dueDate: dueDate)
        
        guard let bearer = bearer else {
            print("Error: Supplied Bearer token was not valid.")
            completion(nil)
            return
        }
        
        guard let url = baseURL?.appendingPathComponent("/gigs") else {
            print("Error: Supplied URL was not valid.")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .iso8601
        do {
            let data = try jsonEncoder.encode(newGig)
            request.httpBody = data
        } catch {
            print("Error attempting to encode New Gig into JSON format: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                completion(error)
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            self.gigs.append(newGig)
            completion(nil)
            
        }.resume()
        
    }
    
}
