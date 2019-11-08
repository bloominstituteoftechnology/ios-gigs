//
//  GigController.swift
//  iosGigs
//
//  Created by denis cedeno on 11/5/19.
//  Copyright © 2019 DenCedeno Co. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
}

class GigController{
    var gigs: [Gig] = []
    var bearer: Bearer?
    
    private let baseUrl = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    // create function for sign up
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        
        let signUpURL = baseUrl.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do{
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            //check for errors
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200{
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let error = error {
                completion(error)
                return
            }
            //now we know it worked we can finish the completion
            completion(nil)
        } .resume()
        
    }
    
    // create function for sign in
    func signIn(with user: User, completion: @escaping (Error?) -> ()) {
        
        let logInURL = baseUrl.appendingPathComponent("users/login")
        
        var request = URLRequest(url: logInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do{
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            //check for errors
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200{
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
            do{
                self.bearer = try decoder.decode(Bearer.self, from: data)
            } catch {
                print("Erorr decoding bearer objecgt: \(error)")
                completion(error)
                return
            }
            
            //now we know it worked we can finish the completion
            completion(nil)
        } .resume()
        
    }
    // create function for fetching all gigs
    func fetchAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let allGigsURL = baseUrl.appendingPathComponent("gigs")
        var request = URLRequest(url: allGigsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            if let error = error {
                print("Error receiving gigs data: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let gigs = try decoder.decode([Gig].self, from: data)
                self.gigs = gigs
                completion(.success(gigs))
            } catch {
                print("Error decoding gig objects: \(error)" )
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    //    Creating a gig and adding it to the API to the API via a POST request. If the request is successful, append the gig to your local array of Gigs.
    
    func createGigs(with gig: Gig, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let postGigsURL = baseUrl.appendingPathComponent("gigs")
        var request = URLRequest(url: postGigsURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .iso8601
        do{
            let jsonData = try jsonEncoder.encode(gig)
            request.httpBody = jsonData
            print(gig)
        } catch {
            print("Error encoding user object: \(error)")
            completion(.failure(.noDecode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            //check for errors
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.failure(.badAuth))
                return
            }
            
            if let _ = error {
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            //now we know it worked we can finish the completion
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let gigs = try decoder.decode(Gig.self, from: data)
                self.gigs.append(gigs)
                print(gigs)
                completion(.success(true))
            } catch {
                print("Error decoding gig objects: \(error)" )
                completion(.failure(.noDecode))
                return
            }
            //completion(.success(true))
        } .resume()
        
        
    }
}
