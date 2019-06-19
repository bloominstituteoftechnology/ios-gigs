//
//  GigController.swift
//  Gigs
//
//  Created by Jake Connerly on 6/19/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class GigController {
    
    //
    //MARK: - Properties
    //
    
    var bearer: Bearer?
    let baseUrl = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    //
    //MARK: - Sign Up Method
    //
    
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        let signUpurl = baseUrl.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpurl)
        request.httpMethod = HTTPMethod.post.rawValue //setting up ability to send info to api
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user) //user has to conform to codable
            request.httpBody = jsonData
        }catch{
            print("error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 { //error response 200 is OK or sucessful response
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
    
    //
    //MARK: - Sign In Method
    //
    
    func logIn(with user: User, completion: @escaping (Error?) -> ()) {
        let logInUrl = baseUrl.appendingPathComponent("users/login")
        
        var request = URLRequest(url: logInUrl)
        request.httpMethod = HTTPMethod.post.rawValue //setting up ability to send info to api
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user) //user has to conform to codable
            request.httpBody = jsonData
        }catch{
            print("error encoding user object: \(error)")
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
            }catch {
                completion(error)
                return
            }
            
            completion(nil)
            }.resume()
    }
}
