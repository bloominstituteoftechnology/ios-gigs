//
//  GigController.swift
//  Gigs
//
//  Created by Bradley Yin on 8/7/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation


class GigController {
    var bearer: Bearer?
    var baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    func signUp(with username: String, password: String, completion: @escaping (Error?)-> Void){
        let signUpURL = baseURL.appendingPathComponent("users/signup")
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let user = User(username: username, password: password)
        do {
            let userData = try JSONEncoder().encode(user)
            request.httpBody = userData
        }catch{
            print("Error encoding User: \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("Status code not 200, it's: \(response.statusCode)")
            }
            if let error = error {
                print("Error creating user: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func login(with username: String, password: String, completion: @escaping (Error?) -> Void){
        let loginURL = baseURL.appendingPathComponent("users/login")
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let user = User(username: username, password: password)
        do {
            let userData = try JSONEncoder().encode(user)
            request.httpBody = userData
        }catch{
            print("Error encoding User: \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("Status code not 200, it's: \(response.statusCode)")
            }
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }
            if let error = error {
                print("Error creating user: \(error)")
                completion(error)
                return
            }
            do{
                let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                self.bearer = bearer
                completion(nil)
            }catch{
                NSLog("Error decoding data: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    enum HTTPMethod: String{
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
}
