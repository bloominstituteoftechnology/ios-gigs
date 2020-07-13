//
//  GigController.swift
//  gig
//
//  Created by Gladymir Philippe on 7/10/20.
//  Copyright © 2020 Gladymir Philippe. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
}

class GigController {

    //Bearer and baseURL variables to hold bearer token data and URl for API respectively.
    var bearer: Bearer?
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")

    //Array of Gig Objects used to store and fetch created gigs.
    var gigs: [Gig] = []

    //Function to Sign Up a new user.
    func signUp(for user: User, completion: @escaping (Error?) -> Void) {

        //Complete full API URL for Sign Up Function
        guard let baseURL = baseURL else { return }
        let signUpURL = baseURL.appendingPathComponent("/users/signup")

        //Create new HTTPRequest to handle Sign Up
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        //Create JSONEncoder to prepare text for being wrapped and sent to API.
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding User object whilst creating an account: \(error)")
            completion(error)
            return
        }

        //URLSession Data Task to handle execution and return of data fron API web server.
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
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

    //Function to handle a existing user signing into their account.
    func signIn(for user: User, completion: @escaping (Error?) -> Void) {
        //Complete full API URL to allow existing users to sign in.
        guard let baseURL = baseURL else { return }
        let signInURL = baseURL.appendingPathComponent("/users/login")

        //Create a new HTTPRequest to handle Sign In
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        //Create JSON Encoder property to handle encoding of data sent to the API.
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding User object whilst attempting to Sign In: \(error)")
            completion(error)
            return
        }

        //Create URLSession to handle communication to the API.
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
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
                print("Error decoding bearer object from JSON data: \(error)")
                completion(error)
                return
            }

            completion(nil)

        }.resume()
    }

    //Function to get all Gigs from API
    func getAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let gigURL = baseURL?.appendingPathComponent("/gigs/"),
            let bearer = bearer else {
                completion(.failure(.noAuth))
                return
        }

        var request = URLRequest(url: gigURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 401 {
                    completion(.failure(.badAuth))
                    return
                }
            }

            if let _ = error {
                completion(.failure(.otherError))
                return
            }

            guard let data = data else {
                completion(.failure(.badData))
                return
            }

            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            do {
                let jsonData = try jsonDecoder.decode([Gig].self, from: data)
                self.gigs = jsonData
                completion(.success(jsonData))
            } catch {
                print("Error decoding JSON Data: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }

    func createGig(for gig: Gig, completion: @escaping (Error?) -> Void) {
        guard let createGigURL = baseURL?.appendingPathComponent("/gigs/"),
            let bearer = bearer else {
                completion(nil)
                return
        }

        var request = URLRequest(url: createGigURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")

        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .iso8601
        do {
            let jsonData = try jsonEncoder.encode(gig)
            request.httpBody = jsonData
        } catch {
            print("Error encoding new Gig data: \(error)")
            completion(error)
            return
        }

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(error)
                return
            }

            if let response = response as? HTTPURLResponse {
                if response.statusCode == 401 {
                    completion(nil)
                    return
                } else if response.statusCode == 200{
                    self.gigs.append(gig)
                }
            }

            completion(nil)
        }.resume()

    }
}
