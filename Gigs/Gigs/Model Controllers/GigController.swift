//
//  GigController.swift
//  Gigs
//
//  Created by scott harris on 2/12/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum HTTPHeaderValue: String {
    case json = "application/json"
}

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case badData
    case otherError
    case noDecode
    case noEncode
    
}

class GigController {
    
    var bearer: Bearer?
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    var gigs: [Gig] = []
    
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        let signUpURL = baseURL.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(HTTPHeaderValue.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(user)
            request.httpBody = data
        } catch {
            NSLog("Error encoding user object \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                NSLog("Error recieved From Data Task \(error)")
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
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        let signUpURL = baseURL.appendingPathComponent("users/login")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(HTTPHeaderValue.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(user)
            request.httpBody = data
        } catch {
            NSLog("Error encoding user object \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error recieved From Data Task \(error)")
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
            
            do {
                let decoder = JSONDecoder()
                self.bearer = try decoder.decode(Bearer.self, from: data)
                
            } catch {
                NSLog("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            
            
        }.resume()
        
        
    }
    
    func fetchGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let gigsURL = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: gigsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error receiveing gigs data: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            do {
                let gigs = try jsonDecoder.decode([Gig].self, from: data)
                self.gigs = gigs
                
            } catch {
                completion(.failure(.noDecode))
            }
            
            completion(.success(self.gigs))
            
        }.resume()
        
    }
    
    func createGig(gig: Gig, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        let gigsURL = baseURL.appendingPathComponent("gigs")
        var request = URLRequest(url: gigsURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let encodedData = try encoder.encode(gig)
            request.httpBody = encodedData
        } catch {
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error receiveing gig detail data: \(error)")
                completion(.failure(.otherError))
                return
            }
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            do {
                let gig = try jsonDecoder.decode(Gig.self, from: data)
                self.gigs.append(gig)
            } catch {
                completion(.failure(.noDecode))
                return
            }
            
            completion(.success(gig))
            
        }.resume()
        
        
    }
    
    
    
}
