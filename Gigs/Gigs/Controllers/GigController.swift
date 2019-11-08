//
//  GigController.swift
//  Gigs
//
//  Created by Jessie Ann Griffin on 9/10/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import Foundation

class GigController {
    
    private let baseUrl = URL(string: "https://lambdagigs.vapor.cloud/api")!
    var bearer: Bearer?
    var gigs: [Gig] = []
    
    private var gigUserLogin: URL? {
        let fileManager = FileManager.default
        guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documents.appendingPathComponent("ReadingList.plist")
    }
    
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        
        let signUpUrl = baseUrl.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding a user object: \(error)")
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
    
    func logIn(with user: User, completion: @escaping (Error?) -> Void) {
        let logInUrl = baseUrl.appendingPathComponent("users/login")
        
        var request = URLRequest(url: logInUrl)
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
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
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
            let jsonDecoder = JSONDecoder()
            do {
                self.bearer = try jsonDecoder.decode(Bearer.self, from: data)
            } catch {
                print("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func fetchAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) { // uses GET
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let allGigsUrl = baseUrl.appendingPathComponent("gigs/")
        
        var request = URLRequest(url: allGigsUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                //print(reason)
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
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let gigTitles = try decoder.decode([Gig].self, from: data)
                self.gigs = gigTitles
                completion(.success(gigTitles))
            } catch {
                print("Error decoding Gig titles: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func createGig(for gig: Gig, completion: @escaping (NetworkError?) -> Void) { // uses POST
        guard let bearer = bearer else {
            completion(.noAuth)
            return
        }
        
        let newGigUrl = baseUrl.appendingPathComponent("gigs/")
        
        var request = URLRequest(url: newGigUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(gig)
            request.httpBody = jsonData
            self.gigs.append(gig)
            print("New gig endcoded")
        } catch {
            print("Error encoding gig object: \(error)")
            completion(.noEncode)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.badAuth)
                return
            }

            if let _ = error {
                completion(.otherError)
                return
            }

            completion(nil)
//            guard let data = data else {
//                completion(.badData)
//                return
//            }
//
//            let decoder = JSONDecoder()
//            do {
//                let decodedGig = try decoder.decode(Gig.self, from: data)
//                self.gigs.append(decodedGig)
//                completion(nil)
//                print("New gig add successful")
//            } catch {
//                print("Error decoding single gig: \(error)")
//                completion(.noDecode)
//                return
//            }

        }.resume()
    }
}
