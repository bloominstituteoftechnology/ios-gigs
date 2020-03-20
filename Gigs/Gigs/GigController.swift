//
//  GigController.swift
//  Gigs
//
//  Created by Lambda_School_Loaner_241 on 3/17/20.
//  Copyright © 2020 Lambda_School_Loaner_241. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
case get = "GET"
case post = "POST"
}

class GigController {
    var bearer: Bearer?
    let baseUrl = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    
    func signUp(with user: User, completion: @escaping (Error?)->Void){
        
        let signUpUrl = baseUrl.appendingPathComponent("users/signup")
        
        
        // URL request
        var request = URLRequest(url: signUpUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // encode the user to put in our body
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print(" Error encoding the user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            guard error == nil else {
                completion(error)
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
    
    
    
}
