//
//  GigController.swift
//  Gigg(s)
//
//  Created by Austin Potts on 9/4/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

enum HTTPMethod: String{
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error{
    case ecodingError
    case responseError
    case otherError
    case noData
    case noDecode
}

//Api controller
class GigController {
    
    let baseURL = URL(string: "https://lambdaanimalspotter.vapor.cloud/api")!
    
    var bearer: Bearer?
    
    func signUp(with user: User, completion: @escaping (NetworkError?) -> Void){
        
        //Setup URL
        let signUpURL = baseURL.appendingPathComponent("users")
            .appendingPathComponent("signup")
        
        //Set up a Request URL
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let encoder = JSONEncoder()
        
        do{
            let userData = try encoder.encode(user)
            request.httpBody = userData
            
        } catch {
            NSLog("Error encoding user: \(error)")
            completion(.ecodingError)
            return
        }
        
        //Perform the request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.responseError)
                return
            }
            
            if let error = error{
                NSLog("Error Creating User on Server: \(error)")
                completion(.otherError)
                return
            }
            completion(nil)
            
            }.resume() //Resuming the data task
        
    }
    
    func login(with user: User, completion: @escaping (NetworkError?) -> Void) {
        
        //Set up URL
        
        let loginURL = baseURL.appendingPathComponent("users")
            .appendingPathComponent("login")
        
        //Set up a request
        
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        
        do{
            request.httpBody = try encoder.encode(user)
            
        } catch {
            NSLog("Error: \(error)")
            completion(.ecodingError)
            return
            
        }
        
        
        //Perform the request
        
        URLSession.shared.dataTask(with: request) {(data, response, error)  in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.responseError)
                return
            }
            
            
            
            //Handle Errors
            if let error = error {
                NSLog("Error \(error)")
                completion(.otherError)
                return
            }
            
            guard let data = data else{
                completion(.noData)
                return
            }
            
            do{
                let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                
                self.bearer = bearer
            } catch {
                completion(.noDecode)
                return
            }
            completion(nil)
            
            }.resume()
    }
    
    
}
