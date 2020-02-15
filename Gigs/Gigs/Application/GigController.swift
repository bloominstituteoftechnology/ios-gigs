//
//  GigController.swift
//  Gigs
//
//  Created by Casualty on 9/10/19.
//  Copyright © 2019 Thomas Dye. All rights reserved.
//

import Foundation


class GigController {
    var bearer: Bearer?
    var gigs: [Gig] = []
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    func signUp(with username: String, password: String, completion: @escaping (Error?) -> Void){
        
        let signUpURL = baseURL.appendingPathComponent("users/signup")
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let user = User(username: username, password: password)
        
        do {
            let userData = try JSONEncoder().encode(user)
            request.httpBody = userData
        }catch{
            print("Error encoding user: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("Error: \(response.statusCode)")
            }
            if let error = error {
                print("Error creating user: \(error)")
                completion(error)
                return
            }
            completion(nil)
            }.resume()
    }
    
    func signIn(with username: String, password: String, completion: @escaping (Error?) -> Void){
        
        let loginURL = baseURL.appendingPathComponent("users/login")
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let user = User(username: username, password: password)
        
        do {
            let userData = try JSONEncoder().encode(user)
            request.httpBody = userData
        }catch{
            print("Error encoding User: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
    
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                print("Error: \(response.statusCode)")
            }
            
            guard let data = data else {
                print("No data")
                completion(error)
                return
            }
            
            if let error = error {
                print("Error creating user: \(error)")
                completion(error)
                return
            }
            
            do{
                let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                self.bearer = bearer
                completion(nil)
            }catch{
                print("Error decoding data: \(error)")
                completion(error)
                return
            }
            }.resume()
    }
    
    func fetchAllGigs(completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        guard let bearer = bearer  else { return }
        let requestURL = baseURL.appendingPathComponent("gigs")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error{
                print("Error fetching gigs: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else{
                print("No data return on fetch all data")
                completion(.failure(.badData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let gigs = try decoder.decode([Gig].self, from: data)
                print("gigs", gigs)
                self.gigs = gigs
                completion(.success(true))
            } catch {
                print("Error decoding gigs")
                completion(.failure(.noDecode))
            }
            }.resume()
    }
    
    func createGig(title: String, description: String, dueDate: Date, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
        
        guard let bearer = bearer else { return }
        let requestURL = baseURL.appendingPathComponent("gigs")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let gig = Gig(title: title, description: description, dueDate: dueDate)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let data = try encoder.encode(gig)
            request.httpBody = data
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error{
                    print("Error making gig \(error)")
                }
                completion(.success(gig))
                }.resume()
        } catch {
            print("Error: \(error)")
        }
    }
}
