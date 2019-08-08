//
//  GigController.swift
//  Gigs
//
//  Created by Bradley Yin on 8/7/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation


class GigController {
    var bearer: Bearer?
    
    var gigs: [Gig] = []
    
    var baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    func signUp(with username: String, password: String, completion: @escaping (Error?)-> Void){
        let signUpURL = baseURL.appendingPathComponent("users/signup")
        var request = URLRequest(url: signUpURL)
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
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("Status code not 200, it's: \(response.statusCode)")
            }
            if let error = error {
                print("Error creating user: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func login(with username: String, password: String, completion: @escaping (Error?) -> Void){
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
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("Status code not 200, it's: \(response.statusCode)")
            }
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
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
                NSLog("Error decoding data: \(error)")
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
                NSLog("Error fetching all gigs: \(error)")
                print("Error fetching all gigs: \(error)")
                completion(.failure(.otherError(error)))
                return
            }
            guard let data = data else{
                NSLog("No data return on fetch all data")
                print("No data return on fetch all data")
                completion(.failure(.noData))
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
                NSLog("Error decoding all Gigs")
                completion(.failure(.noDecode))
            }
        }.resume()
    }
    
    func createGig (title: String, description: String, dueDate: Date, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
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
                    NSLog("Error creating gig: \(error)")
                }
                completion(.success(gig))
            }.resume()
        } catch {
            NSLog("Error encoding gig: \(error)")
        }
    }
    
    enum HTTPMethod: String{
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
}

enum NetworkError: Error{
    case noDecode
    case noToken
    case noData
    case otherError(Error)
}
