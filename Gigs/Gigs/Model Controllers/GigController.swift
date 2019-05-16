//
//  GigController.swift
//  Gigs
//
//  Created by Jonathan Ferrer on 5/16/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit

class GigController {

    var gigs: [Gig] = []
    var bearer: Bearer?
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!



    


    func getAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void ) {

        guard let bearer = bearer else {
            NSLog("No token available")
            completion(.failure(.noBearer))
            return
        }

        let requestURL = baseURL
            .appendingPathComponent("gigs")

        var request = URLRequest(url: requestURL)

        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { (data, response, error) in

            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }

            if let error = error {
                NSLog("Error getting animal names: \(error)")
                completion(.failure(.apiError))
                return
            }

            guard let data = data else {
                completion(.failure(.noDataReturned))
                return
            }

            let decoder = JSONDecoder()

            do{
                let gigs = try decoder.decode([Gig].self, from: data)
                completion(.success(gigs))


            } catch {
                NSLog("Error decoding gigs: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }



    func signUp(with username: String, password: String, completion: @escaping (Error?) -> Void) {

        let requestURL = baseURL.appendingPathComponent("users/signup")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let user = User(username: username, password: password)

        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error encoding User: \(error)")
            completion(error)
            return
        }

        URLSession.shared.dataTask(with: request) { (_, response, error) in

            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError())
                return
            }

            if let error = error {
                NSLog("Error signing up: \(error)")
                completion(error)
                return
            }

            completion(nil)
            }.resume()
    }

    func logIn(with username: String, password: String, completion: @escaping (Error?) -> Void) {
        let requestURL = baseURL.appendingPathComponent("users/login")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let user = User(username: username, password: password)

        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error encoding User: \(error)")
            completion(error)
            return
        }

        URLSession.shared.dataTask(with: request) { (data, response, error) in

            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError())
                return
            }

            if let error = error {
                NSLog("Error logging in: \(error)")
                completion(error)
                return
            }


            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }

            let decoder = JSONDecoder()

            do {
                let bearer = try decoder.decode(Bearer.self, from: data)

                // We now have the bearer to authenticate the other requests
                self.bearer = bearer
                completion(nil)
            } catch {
                NSLog("Error decoding Bearer: \(error)")
                completion(error)
                return
            }
            }.resume()
    }

    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }

    enum NetworkError: Error {
        case noDataReturned
        case noBearer
        case badAuth
        case apiError
        case noDecode
    }

}
