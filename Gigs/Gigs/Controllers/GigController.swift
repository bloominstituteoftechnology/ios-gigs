//
//  GigController.swift
//  Gigs
//
//  Created by Joseph Rogers on 11/4/19.
//  Copyright © 2019 Joseph Rogers. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class GigController {
    
    //MARK: Properties
    private let baseUrl = URL(string: "https://lambdagigs.vapor.cloud/api")!
    var bearer: Bearer?
    
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
           
           let signUpURL = baseUrl.appendingPathComponent("users/signup")
           //creates request
           var request = URLRequest(url: signUpURL)
           request.httpMethod = HTTPMethod.post.rawValue
           //payload below
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           
           //json encoder. converts the user into json.
           let jsonEncoder = JSONEncoder()
           do {
               let jsonData = try jsonEncoder.encode(user)
               request.httpBody = jsonData
           }catch {
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
       
       // create function for sign in
       
       func signIn(with user: User, completion: @escaping (Error?) -> ()) {
           
                let loginUrl = baseUrl.appendingPathComponent("users/login")
                //creates request
                var request = URLRequest(url: loginUrl)
                request.httpMethod = HTTPMethod.post.rawValue
                //payload below
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                //json encoder. converts the user into json.
                let jsonEncoder = JSONEncoder()
                do {
                    let jsonData = try jsonEncoder.encode(user)
                    request.httpBody = jsonData
                }catch {
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
    
}
