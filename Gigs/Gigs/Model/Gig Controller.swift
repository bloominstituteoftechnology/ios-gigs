//
//  Gig Controller.swift
//  Gigs
//
//  Created by Bhawnish Kumar on 3/12/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case badUrl
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
}

class GigController {
    
    var gigs: [Gig] = []
    private let baseUrl = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    
    var bearer: Bearer?

    // create function for sign up
    func signUp(with user: User, completion: @escaping (Error?) ->  ()) {
        let signUpUrl = baseUrl.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error catching the data \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: response.description, code: response.statusCode , userInfo: nil))
                return
            }
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
            }.resume()
    }
    // create function for sign in
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
              NSLog("Error encoding user object: \(error)")
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
                  completion(NSError(domain: response.description, code: response.statusCode, userInfo: nil))
                  return
              }
            
            guard let data = data else {
                completion(NSError(domain: "Data not found", code: 99, userInfo: nil))
          return
            }
              let decoder = JSONDecoder()
            do {
                self.bearer = try decoder.decode(Bearer.self, from: data)
            } catch {
                NSLog("Error decoding error object \(error)")
                completion(error)
                return
            }
              completion(nil)
          }.resume()
      }
    // fetching all the gigs in order to create a gig, whichh means to gather gigs.
    
    func fetchAllGigsNames(completion: @escaping (Result<[String], NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let allGigsUrl = baseUrl.appendingPathComponent("/gigs")
        
        var request = URLRequest(url: allGigsUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error receiving animal name data: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                // User is not authorized (no token or bad token)
                NSLog("Server responded with 401 status code (not authorized).")
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                NSLog("Server responded with no data to decode.sup")
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let gigNames = try decoder.decode([String].self, from: data)
                completion(.success(gigNames))
            } catch {
                NSLog("Error decoding animal objects: \(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
    }
    
    
    
    
    
    // fetching one gig
    func gigsDetail(for gigName: String, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
         guard let bearer = bearer else {
             completion(.failure(.noAuth))
             return
         }
         
         let gigsUrl = baseUrl.appendingPathComponent("/gigs\(gigName)")
         
         var request = URLRequest(url: gigsUrl)
         request.httpMethod = HTTPMethod.post.rawValue
         request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
         
         URLSession.shared.dataTask(with: request) { data, response, error in
             if let error = error {
                 NSLog("Error receiving gig name data: \(error)")
                 completion(.failure(.otherError))
                 return
             }
             
             if let response = response as? HTTPURLResponse,
                 response.statusCode == 401 {
                 // User is not authorized (no token or bad token)
                 NSLog("Server responded with 401 status code (not authorized).")
                 completion(.failure(.badAuth))
                 return
             }
             
             guard let data = data else {
                 NSLog("Server responded with no data to decode.sup")
                 completion(.failure(.badData))
                 return
             }
             
             let decoder = JSONDecoder()
             decoder.dateDecodingStrategy = .secondsSince1970
             do {
                 let gig = try decoder.decode(Gig.self, from: data)
                 completion(.success(gig))
             } catch {
                 NSLog("Error decoding gig object \(gigName): \(error)")
                 completion(.failure(.noDecode))
             }
         }.resume()
     }
      
    
    
   
}
