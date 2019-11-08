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

class GigController{
    
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
    // create function for fetching all gig names
    
    // create function for fetching a specific gig
    
    // create function to fetch image
    
}
