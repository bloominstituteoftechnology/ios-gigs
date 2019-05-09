//
//  GigController.swift
//  Gigs
//
//  Created by Christopher Aronson on 5/9/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class GigController {
    // MARK: - Properties
    private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    var gigs: [Gig] = []
    var bearer: Bearer?
    
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        let signUpUrl = baseURL.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpUrl)
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
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo:nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
            }.resume()
    }
    
    func signIn(with user: User, completion: @escaping (Error?) -> ()) {
        let loginUrl = baseURL.appendingPathComponent("users/login")

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
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo:nil))
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

    func fetchGigs(completion: @escaping (Error?) -> Void) {
        guard let bearer = bearer else {
            completion(NSError(domain: "No Auth", code: 12, userInfo: nil))
            return
        }

        let gigsURL = baseURL.appendingPathComponent("gigs")

        var request = URLRequest(url: gigsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(NSError(domain: "No Auth", code: 401, userInfo: nil))
                return
            }

            if let error = error {
                completion(error)
                return
            }

            guard let data = data else {
                completion(error)
                return
            }

            let decoder = JSONDecoder()
            do {
                let allGigs = try decoder.decode([Gig].self, from: data)
                self.gigs = allGigs
                completion(nil)
            } catch {
                print("Error decoding animal objects: \(error)")
                completion(error)
                return
            }
            }.resume()
    }
    
    func createGig(title: String, description: String, dueDate: Date, completion: @escaping (Error?) -> Void) {
        guard let bearer = bearer else {
            completion(NSError(domain: "No Auth", code: 12, userInfo: nil))
            return
        }
        
        let gig = Gig(title: title, dueDate: dueDate, description: description)
        
        let gigsURL = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: gigsURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            request.httpBody = try encoder.encode(gig)
        } catch {
            print(error)
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(NSError(domain: "No Auth", code: 401, userInfo: nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            self.gigs.append(gig)

            }.resume()
    }
    
}
