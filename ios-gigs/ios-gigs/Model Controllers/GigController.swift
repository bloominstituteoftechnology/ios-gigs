//
//  GigController.swift
//  ios-gigs
//
//  Created by Aaron on 9/10/19.
//  Copyright © 2019 AlphaGrade, INC. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case noAuth
    case badData
    case badAuth
    case otherError
    case noDecode
}

class GigController {
    
    var gigs: [Gig] = []
    var bearer: Bearer?
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    var dateFormatter: DateFormatter = {
        let dateFormat =  DateFormatter()
        dateFormat.dateFormat = "MM:DD:YYYY"
        dateFormat.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormat
    }()
    
    var jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
    
    var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
    
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
    
    func fetchGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        let gigsURL = baseURL.appendingPathComponent("gigs")
        var request = URLRequest(url: gigsURL)
        request.httpMethod = "GET"
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            if let _ = error {
                completion(.failure(.otherError))
                return
            }
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
    
            do {
                let gigData = try self.jsonDecoder.decode([Gig].self, from: data)
                self.gigs = gigData
                completion(.success(gigData))
            } catch {
                print("Error decoding data: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func fetchDetails(completion: @escaping (Result<Gig, NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        let gigsURL = baseURL.appendingPathComponent("gigs")
        var request = URLRequest(url: gigsURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            if let error = error {
                print("There was a fetch Error: \(error)")
                completion(.failure(.otherError))
            }
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            do {
                let gig = try self.jsonDecoder.decode(Gig.self, from: data)
                completion(.success(gig))
                return
            } catch {
                print("Error decoding data. \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func addGig(_ gig: Gig, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
        guard let bearer = bearer else { return }
        let addGigURL = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: addGigURL)
        request.httpMethod = "POST"
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        do {
            let jsonData = try jsonEncoder.encode(gig)
            request.httpBody = jsonData
        } catch {
            print("There was an encoding error. \(error)")
            completion(.failure(.badData))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.failure(.badAuth))
                return
            }
            
            
            if let error = error {
                completion(.failure(.otherError))
                print("There was an dataTask error during Post Gig: \(error)")
                return
                
            }
            
            completion(.success(gig))
            
        }.resume()
        
    }
    
    
}
