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
    case otherError(Error)
    case noData
    case noDecode
    case noToken
}

//Api controller
class GigController {
    
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    var bearer: Bearer?
    
    var gigs: [Gig] = []
    
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
                completion(.otherError(error))
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
                completion(.otherError(error))
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
    
    func getAllGigs(completion: @escaping (Result<[String], NetworkError>) -> Void) {
        
        guard let bearer = bearer else {
            completion(.failure(.noToken))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("gigs")
            .appendingPathComponent("all")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request){(data,response,error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.failure(.responseError))
                return
            }
            
            if let error = error {
                NSLog("Error getting posting names: \(error)")
                completion(.failure(.otherError(error)))
                return
            }
            
            
            guard let data = data else{
                completion(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let names = try decoder.decode([String].self, from: data)
                completion(.success(names))
            } catch {
                NSLog("Error decoding name: \(error)")
                completion(.failure(.noDecode))
                return
                
                
            }
            
            }.resume()
    }
    
    func addNewGig(title: String, dueDate: Date, description: String, completion: @escaping (Result<[String], NetworkError>) -> Void) {
        
        guard let bearer = bearer else {
            completion(.failure(.noToken))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("gigs")
            .appendingPathComponent("all")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request){(data,response,error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.failure(.responseError))
                return
            }
            
            if let error = error {
                NSLog("Error getting names: \(error)")
                completion(.failure(.otherError(error)))
                return
            }
            
            
            guard let data = data else{
                completion(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let animalNames = try decoder.decode([String].self, from: data)
                completion(.success(animalNames))
            } catch {
                NSLog("Error decoding  name: \(error)")
                completion(.failure(.noDecode))
                return
                
                
            }
            
            }.resume()
    }
    
    
}
