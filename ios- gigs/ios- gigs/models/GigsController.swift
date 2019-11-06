//
//  GigsController.swift
//  ios- gigs
//
//  Created by Nicolas Rios on 11/5/19.
//  Copyright © 2019 Nicolas Rios. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class GigController {
    
    private let baseUrl = URL(string:"https://lambdagigs.vapor.cloud/api")!
    
    var bearer:Bearer?
    
    func signUp(with user: User,completion: @escaping (Error?) -> ()) {
       let signUpUrl = baseUrl.appendingPathComponent("users/signUp)")
        
    var request = URLRequest(url:signUpUrl)
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
    
}

func signIn(with user: User, completion: @escaping (Error?) -> ()) {
    let loginUrl = baseUrl.appendingPathComponent("users/login")
    
    var request = URLRequest(url: loginUrl)
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


