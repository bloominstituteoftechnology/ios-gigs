//
//  GigController.swift
//  Gigs
//
//  Created by Chris Gonzales on 2/12/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}

class GigController {
    
    // MARK: - Properties
    
    private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    var bearer: Bearer?
    var gigs: [Gig] = []
    
    
    // MARK: - Methods
    
    func createGig(gig: Gig) -> Gig {
        let newGig = gig
        gigs.append(newGig)
        return newGig
    }
    
    
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        
        let signUpURL = baseURL.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do{
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user data: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
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
    
    func logIn(with user: User, completion: @escaping (Error?) -> ()) {
        
        let signInURL = baseURL.appendingPathComponent("users/login")
        
        var request = URLRequest(url: signInURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do{
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user data: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(error)
                return
            }
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
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
                NSLog("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func fetchGigs(completion: @escaping (Result<[Gig], Errors.networkErrors>) ->()){
        let gigUrl = baseURL.appendingPathComponent("gigs")
        guard let bearer = bearer else {
            completion(.failure(.badAuth))
            return
        }
        
        var request = URLRequest(url: gigUrl)
        request.httpMethod  = HTTPMethod.get.rawValue
        request.setValue("Bearer  \(bearer)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                completion(.failure(.otherError))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401{
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            do{
                let allGigs = try decoder.decode([Gig].self, from: data)
                completion(.success(allGigs))
            } catch {
                NSLog("Error decoding gigs array: \(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
    }
    
    func pushGig (gig: Gig, completion: @escaping (Error?) ->()){
        let gigUrl = baseURL.appendingPathComponent("gigs")
        guard let bearer = bearer else {
            completion(Errors.networkErrors.badAuth)
            return
        }
        
        var request = URLRequest(url: gigUrl)
        request.httpMethod  = HTTPMethod.post.rawValue
        request.addValue("Bearer  \(bearer)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           
        let encoder = JSONEncoder()
                    do{
                        request.httpBody = try encoder.encode(gig)
        //                self.gigs.append(gig)
                    } catch {
                        NSLog("Error encoding gigs array: \(error)")
                        completion(Errors.networkErrors.noEncode)
                    }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let _ = error {
                completion(Errors.networkErrors.otherError)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401{
                completion(Errors.networkErrors.networkError)
                return
            }
            self.gigs.append(gig)
        }.resume()
    }
}
