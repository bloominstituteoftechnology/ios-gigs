//
//  GigController.swift
//  Gigs
//
//  Created by Zack Larsen on 12/4/19.
//  Copyright © 2019 Zack Larsen. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delet = "Delete"
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
    
}

class GigController {
    var bearer: Bearer?
    private let baseUrl = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        let signUPUrl = baseUrl.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUPUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) {_, response, error in
            if let error = error {
                completion(error)
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
    func signIn(with user: User, completion: @escaping (Error?) -> ()) {
        let signInUrl = baseUrl.appendingPathComponent("users/login")
        
        var request = URLRequest(url: signInUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
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
            
            let decoder = JSONDecoder()
            do {
                self.bearer = try decoder.decode(Bearer.self, from: data)
            } catch {
                print("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
//    Getting all the gigs the API has. Once you decode the Gigs, set the value of the array of Gigs property you made in this GigController to it, so the table view controller can have a data source.
    func getAllGigs(completion: @escaping (NetworkError?) -> Void) {
        guard let bearer = bearer else {
            completion(.noAuth)
            return
        }
        
        let allGigsURL = baseUrl.appendingPathComponent("gigs")
        
        var request = URLRequest(url: allGigsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                completion(.badAuth)
                return
            }
            
            if let error = error {
                print("Error receiveing Gig data: \(error)")
                completion(.otherError)
                return
            }
            
            guard let data = data else {
                completion(.badData)
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                self.gigs = try decoder.decode([Gig].self, from: data)
                completion(nil)
                
            } catch {
                print("Error decoding Gig objects: \(error)")
                completion(.noDecode)
                return
            }
        }.resume()
        
    }
//    Creating a gig and adding it to the API to the API via a POST request. If the request is successful, append the gig to your local array of Gigs.
    func createGig(with title: String, dueDate: Date, description: String, completion: @escaping (NetworkError?) -> Void) {
        
        let gig = Gig(title: title, dueDate: dueDate, description: description)
        
        guard let bearer = bearer else {
            completion(.noAuth)
            return
        }
        let createGigURL = baseUrl.appendingPathComponent("gigs")
        
        var request = URLRequest(url: createGigURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            request.httpBody = try encoder.encode(gig)
        } catch {
            NSLog("Error encoding gig: \(error)")
            completion(.otherError)
            
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.badAuth)
                return
            }
            
            if let _ = error {
                completion(.otherError)
                return
            }
            
            self.gigs.append(gig)
            completion(nil)
            
        }.resume()
        
    }
//    Add a new variable called var gigs: [Gig] = [] that will be used for storing the fetched and created gigs. This will also be the data source for the table view.
    
    var gigs: [Gig] = []
}
