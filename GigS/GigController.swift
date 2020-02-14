//
//  GigController.swift
//  GigS
//
//  Created by Nick Nguyen on 2/12/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation
import UIKit


enum NetworkError: Error {
    case badUrl
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
    case badImage
}


enum HTTPMethod : String {
    case get = "GET"
    case post = "POST"
}

class GigController {

    var bearer: Bearer?
    
    var gigs : [Gig] = []
    
    
    
 private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
//    MARK: - Sign Up
    func signUp(with user:User,completion: @escaping (Error?) -> ()) {

        let signUpUrl = baseURL.appendingPathComponent("users/signup")

        var request = URLRequest(url: signUpUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object:\(error)")
            completion(error)
            return
        }

        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                completion(error)
                return
            }
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                print(response)
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
            }
                 completion(nil) // A-ha
        }.resume()

    }

    
//    }
    func signIn(with user: User, completion: @escaping (Error?) -> ()) {
           // create endpoint-specific URL
           let signInUrl = baseURL.appendingPathComponent("users/login")
           
           // create a URLRequest from above
           var request = URLRequest(url: signInUrl)
           
           // modify the request for POST, add proper headers
           request.httpMethod = HTTPMethod.post.rawValue
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           
           // encode the user model to JSON, attach as request body
           let jsonEncoder = JSONEncoder()
           do {
               let jsonData = try jsonEncoder.encode(user)
               request.httpBody = jsonData
           } catch {
               NSLog("Error encoding user object: \(error)")
               completion(error)
               return
           }
           
           // set up data task and handle response
           URLSession.shared.dataTask(with: request) { (data, response, error) in
               // handle errors (like no internet connectivity, or anything that generates and Error object)
               if let error = error {
                   completion(error)
                   return
               }
               
               // handle client and server errors that generate non 200 status codes
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
                   NSLog("Error decoding bearer object: \(error)")
                   completion(error)
                   return
               }
               
               // if we get this far, the response contained no errors, so log in was successful
               completion(nil)
           }.resume()
       }
    
    //MARK:- Fetch all gigs
 
    func fetchAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
          guard let bearer = bearer else {
                     completion(.failure(.noAuth))
                     return
                 }
        
           let allGigsUrl = baseURL.appendingPathComponent("gigs") // dont need the /
           var request = URLRequest(url: allGigsUrl)
           request.httpMethod = HTTPMethod.get.rawValue
           request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
           URLSession.shared.dataTask(with: request) { (data, response, error) in
               if let error = error {
                   NSLog("Error receiving gigs data: \(error)")
                   completion(.failure(.otherError))
                   return
               }
               if let response = response as? HTTPURLResponse,
                   response.statusCode == 401 {
                   completion(.failure(.badAuth))
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
                   completion(.success(gigs))
               } catch {
                   NSLog("Error decoding gigs object: \(error)")
                   completion(.failure(.noDecode))
                   return
               }
           }.resume()
       }
    
// MARK: - Create Gig Function
    
    func createGig(with gig: Gig, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let postGigUrl = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: postGigUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .iso8601 // "A-ha 3"
        do {
            let jsonData = try jsonEncoder.encode(gig)
            request.httpBody = jsonData
            print(gig)
        } catch {
            print("Error encoding gig object: \(error.localizedDescription)")
            completion(.failure(.noDecode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let _ = error {
                completion(.failure(.otherError))
                return
            }
            
            self.gigs.append(gig)
            
            completion(.success(gig))
            
        }.resume()
    }
  
    }
    
  


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

