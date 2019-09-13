//
//  GigController.swift
//  Gigs
//
//  Created by Joel Groomer on 9/10/19.
//  Copyright © 2019 julltron. All rights reserved.
//

import Foundation

let appJSON = "application/json"
let contentType = "Content-Type"
let authHeader = "Authorization"

enum HttpMethod: String {
    case post = "POST"
    case get = "GET"
}

class GigController {
    var bearer: Bearer?
    var baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    var gigs: [Gig] = []

    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        let signUpUrl = baseURL.appendingPathComponent("users/signup")
        var request = URLRequest(url: signUpUrl)
        request.httpMethod = HttpMethod.post.rawValue
        request.setValue(appJSON, forHTTPHeaderField: contentType)
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(user)
            request.httpBody = data
        } catch {
            print("Error encoding user to JSON: \(error)")
            completion(NSError(domain: "", code: 1, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, res, err) in
            if let err = err {
                print("Error performing sign up data task: \(err)")
                completion(err)
                return
            }
            
            if let res = res as? HTTPURLResponse, res.statusCode != 200 {
                completion(NSError(domain: "", code: res.statusCode, userInfo: nil))
            }
            
            completion(nil)
        }.resume()
    }
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        let signInUrl = baseURL.appendingPathComponent("users/login")
        var request = URLRequest(url: signInUrl)
        request.httpMethod = HttpMethod.post.rawValue
        request.setValue(appJSON, forHTTPHeaderField: contentType)
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(user)
            request.httpBody = data
        } catch {
            print("Error encoding user to JSON: \(error)")
            completion(NSError(domain: "", code: 2, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, res, err) in
            if let err = err {
                print("Error performing sign in data task: \(err)")
                completion(err)
                return
            }
            
            if let res = res as? HTTPURLResponse, res.statusCode != 200 {
                completion(NSError(domain: "", code: res.statusCode, userInfo: nil))
                return
            }
            
            guard let data = data else {
                completion(NSError(domain: "", code: 3, userInfo: nil))
                return
            }
            let decoder = JSONDecoder()
            do {
                self.bearer = try decoder.decode(Bearer.self, from: data)
            } catch {
                print("Error decoding bearer: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func getAllGigs(completion: @escaping (Error?) -> Void) {
        guard let bearer = bearer else {
            completion(NSError(domain: "", code: 4, userInfo: nil))
            return
        }
        let gigsUrl = baseURL.appendingPathComponent("gigs")
        var request = URLRequest(url: gigsUrl)
        request.httpMethod = HttpMethod.get.rawValue
        request.setValue(bearer.bearerString, forHTTPHeaderField: authHeader)
        
        URLSession.shared.dataTask(with: request) { (data, res, err) in
            if let err = err {
                print("Error getting gigs: \(err)")
                completion(err)
                return
            }
            
            if let res = res as? HTTPURLResponse, res.statusCode != 200 {
                completion(NSError(domain: "", code: res.statusCode, userInfo: nil))
                return
            }
            
            guard let data = data else {
                completion(NSError(domain: "", code: 4, userInfo: nil))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                self.gigs = try decoder.decode([Gig].self, from: data)
            } catch {
                print("Error decoding gigs: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func addGig(_ gig: Gig, completion: @escaping (Error?) -> Void) {
        guard let bearer = bearer else {
            completion(NSError(domain: "", code: 5, userInfo: nil))
            return
        }
        let addGigUrl = baseURL.appendingPathComponent("gigs")
        var request = URLRequest(url: addGigUrl)
        request.httpMethod = HttpMethod.post.rawValue
        request.setValue(bearer.bearerString, forHTTPHeaderField: authHeader)
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let gigData = try encoder.encode(gig)
            request.httpBody = gigData
        } catch {
            print("Error encoding gig: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, res, err) in
            if let err = err {
                completion(err)
                return
            }
            
            if let res = res as? HTTPURLResponse, res.statusCode != 200 {
                completion(NSError(domain: "", code: res.statusCode, userInfo: nil))
                return
            }
            
            completion(nil)
        }
    }
}
