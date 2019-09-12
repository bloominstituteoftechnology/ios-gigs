//
//  GigController.swift
//  ios-gigs
//
//  Created by Aaron on 9/10/19.
//  Copyright © 2019 AlphaGrade, INC. All rights reserved.
//

import Foundation


class GigController {
    
    var bearer: Bearer?
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")
    
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        guard let baseURL = baseURL else { return }
        let signUpURL = baseURL.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("There was an encoding error. \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
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
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        guard let baseURL = baseURL else {return}
        let signInUrl = baseURL.appendingPathComponent("/users/login")
        var request = URLRequest(url: signInUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print(error)
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
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
                print("Error Decoding bearer object: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
        
    }
        
    

}
