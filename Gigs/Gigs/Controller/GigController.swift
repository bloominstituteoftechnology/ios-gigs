//
//  GigController.swift
//  Gigs
//
//  Created by Bradley Diroff on 3/11/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class GigController {
    
    var bearer: Bearer?
    
        private let baseUrl = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
         let signUpUrl = baseUrl.appendingPathComponent("users/signup")
         
         var request = URLRequest(url: signUpUrl)
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
         
         URLSession.shared.dataTask(with: request) { _, response, error in
             if let error = error {
                 completion(error)
                 return
             }
             
             if let response = response as? HTTPURLResponse,
                 response.statusCode != 200 {
                 completion(NSError(domain: response.description, code: response.statusCode, userInfo: nil))
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
                 completion(nil)
             } catch {
                 NSLog("Error decoding bearer object: \(error)")
                 completion(error)
             }
         }.resume()
     }
    
}
