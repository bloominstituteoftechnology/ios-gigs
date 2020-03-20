//
//  GigController.swift
//  Gigs
//
//  Created by David Williams on 3/17/20.
//  Copyright © 2020 david williams. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case noAuth
    case unauthorized
    case otherError(Error)
    case noData
    case decodeFailed
}

class GigController {
    
     var bearer: Bearer?
    var gigs: [Gig] = []
    
    private let baseUrl = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
           let signUpUrl = baseUrl.appendingPathComponent("users/signup")
           
           var request = URLRequest(url: signUpUrl)
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
           
           URLSession.shared.dataTask(with: request) { (_, response, error) in
               guard error == nil else { completion(error)
                   return
               }
               
               if let response = response as? HTTPURLResponse,
                   response.statusCode != 200 {
                   completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                   return
               }
               
               completion(nil)
           }.resume()
       }
       
       func signIn(with user: User, completion: @escaping (Error?) -> Void) {
           let loginURL = baseUrl.appendingPathComponent("users/login")
           
           var request = URLRequest(url: loginURL)
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
               
               let decoder = JSONDecoder()
               do {
                   self.bearer = try decoder.decode(Bearer.self, from: data)
               } catch {
                   print("Error decoding bearer object: \(error)")
                   completion(error)
                   return
               }
               
               completion(nil)
           }.resume()
       }
    
    func fetchAllGigs(completion: @escaping (Result<[String], NetworkError>) -> Void) {
        guard let bearer = bearer else {
                   completion(.failure(.noAuth))
                   return
               }
               
               let allGigsUrl = baseUrl.appendingPathComponent("gigs/all")
               
               var request = URLRequest(url: allGigsUrl)
               request.httpMethod = HTTPMethod.get.rawValue
               request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
               
               URLSession.shared.dataTask(with: request) { (data, response, error) in
                   if let response = response as? HTTPURLResponse,
                       response.statusCode == 401 {
                       completion(.failure(.unauthorized))
                   }
                   
                   guard error == nil else {
                       completion(.failure(.otherError(error!)))
                       return
                   }
                   
                   guard let data = data else {
                       completion(.failure(.noData))
                       return
                   }
                   
                   let decoder = JSONDecoder()
                   do {
                       let gigNames = try decoder.decode([String].self, from: data)
                       completion(.success(gigNames))
                   } catch {
                       completion(.failure(.decodeFailed))
                   }
               }.resume()
           }
           
           func fetchDetails(for gigName: String, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
               guard let bearer = bearer else {
                   completion(.failure(.noAuth))
                   return
               }
               
               let gigUrl = baseUrl.appendingPathComponent("gigs/\(gigName)")
               
               var request = URLRequest(url: gigUrl)
               request.httpMethod = HTTPMethod.get.rawValue
               request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
               
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let response = response as? HTTPURLResponse,
                    response.statusCode == 401 {
                    completion(.failure(.unauthorized))
                }
                
                guard error == nil else {
                    completion(.failure(.otherError(error!)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                do {
                    let gig = try decoder.decode(Gig.self, from: data)
                    completion(.success(gig))
                } catch {
                    completion(.failure(.decodeFailed))
                }
            }.resume()
    }
    
    func createGig(with title: String, date: Date, description: String) {
        let gig = Gig(title: title, description: description, dueDate: date)
        gigs.append(gig)
    }
}
