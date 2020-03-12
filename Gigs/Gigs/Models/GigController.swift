//
//  GigController.swift
//  Gigs
//
//  Created by Karen Rodriguez on 3/11/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import Foundation
//Create http methods enum to avoid human error
enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case badUrl
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
}

class GigController {
    var bearer: Bearer?
    let baseURL: URL = URL(fileURLWithPath: "https://lambdagigs.vapor.cloud/api")
    var gigs: [Gig] = []
    
    // Sign up method
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        // first create sign up URL
        let signUpURL = baseURL.appendingPathComponent("users/signup")
        
        // separate from the url, now we create the request
        var request = URLRequest(url: signUpURL)
        // what kind of request is it?
        request.httpMethod = HTTPMethods.post.rawValue
        // to this we add the content type
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // This is all we need to send a request to the api. The URL and the type of request we want.
        
        //Time to encode the paayload
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            // if we can encode it. add it to the request's body
            request.httpBody = jsonData
        } catch {
            // If we couldn't encode, get out with the error
            NSLog("Couldn't encode JSONData: \(error)")
            completion(error)
            return
        }
        
        // After URL is built, and payload is encoded, send it all out into the wilderness.
        URLSession.shared.dataTask(with: request) { _, response, error in
            // If we receive an error back, just get out lol
            if let error = error {
                completion(error)
                return
            }
            
            // If we get a response, but it isn't 200, also get out.
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                // Create a custom error when calling completion
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            // If we get down here give completion a cookie(aka nil)
            completion(nil)
        }.resume()
    }
    
    // Gonna code LogIn from scratch for the sake of reps
    func logIn(with user: User, completion: @escaping (Error?) -> ()) {
        
        let logInURL = baseURL.appendingPathComponent("users/login")
        
        var request = URLRequest(url: logInURL)
        request.httpMethod = HTTPMethods.post.rawValue
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding data for log in: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "Boom at stastus", code: response.statusCode, userInfo: nil))
                return
            }
            
            guard let data = data else {
                completion(NSError(domain: "Data couldn't be unqrapped", code: 99, userInfo: nil))
                return
            }
            // If the data can be uwrapped, we'll then need to decode it.
            let jsonDecoder = JSONDecoder()
            
            do {
                // If data can be decoded into type Bearer, assign it to self's bearer property.
                let jsonData = try jsonDecoder.decode(Bearer.self, from: data)
                self.bearer = jsonData
                // If everything goes well, just leave with completion as nil
                completion(nil)
                
            } catch {
                NSLog("Error decoding data from log in request: \(error)")
                completion(error)
            }
            completion(nil)
            
        }.resume()
        
        
        
        
    }
    
   // MARK: - Fetch all gigs
    func fetchGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let gigURL = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: gigURL)
        request.httpMethod = HTTPMethods.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error receiving gigs data: \(error)")
                completion(.failure(.otherError))
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
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
                completion(.success(gigs))
            } catch {
                NSLog("Error decoding animal name: \(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
    }
    
    // MARK: - Add a gig
    func postGig(for gig: Gig, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
        
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let gigURL = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: gigURL)
        request.httpMethod = HTTPMethods.post.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        // MARK: - Create payload
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .iso8601
        do {
            let encodedGig = try jsonEncoder.encode(gig)
            request.httpBody = encodedGig
        } catch {
            NSLog("Error encoding the passed in gig: \(error)")
            completion(.failure(.otherError))
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error sending gig data: \(error)")
                completion(.failure(.otherError))
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            // MARK: - If we succeed, we'll get the gig back. We can then add it to the local array
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            do {
                let gig = try jsonDecoder.decode(Gig.self, from: data)
                self.gigs.append(gig)
                completion(.success(gig))
            } catch {
                NSLog("Error decoding animal name: \(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
    }
}
