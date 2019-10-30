//
//  GigController.swift
//  iOS Gigs
//
//  Created by Brandi on 10/30/19.
//  Copyright © 2019 Brandi. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    
}

class GigController {
    
    let baseUrl = URL(string: "https://lambdagigs.vapor.cloud/api")!
    var bearer: Bearer?
    
    // Sign Up
    
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        let signUpURL = baseUrl.appendingPathComponent("users/signup")
               
               var request = URLRequest(url: signUpURL)
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
               
               URLSession.shared.dataTask(with: request) { _, response, error in
                   if let response = response as? HTTPURLResponse,
                       response.statusCode != 200 {
                       completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                       return
                   }
                   
                   if let error = error {
                       completion(error)
                       return
                   }
                   completion(nil)
               }.resume()
    }
    
    // Sign In
    
    func signIn(with user: User, completion: @escaping (Error?) -> ()) {
       let signInURL = baseUrl.appendingPathComponent("users/login")
       
       var request = URLRequest(url: signInURL)
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
           if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
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
               print("Error decoing bearer object: \(error)")
               completion(error)
               return
           }
           
           completion(nil)
       }.resume()
    }
    
}
