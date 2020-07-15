//
//  GigController.swift
//  Gigs
//
//  Created by Sammy Alvarado on 7/11/20.
//  Copyright © 2020 Sammy Alvarado. All rights reserved.
//

import Foundation

class GigiController {

    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }

    enum NetWorkError: Error {
        case noData
        case failedSignUP
        case failedSignIn
        case noToKen
        case sessionTryAgian
        case failToPost
    }


    private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    private lazy var signUpURL = baseURL.appendingPathComponent("/users/signup")
    private lazy var signInURL = baseURL.appendingPathComponent("/users/login")
    private lazy var allGigURL = baseURL.appendingPathComponent("/gigs/")

    var bearer: Bearer?

    var gigs: [Gig] = []

    func signUP(with user: User, completion: @escaping (Result<Bool, NetWorkError>) ->Void) {
        print("SignUpURL = \(signUpURL.absoluteString)")

        var request = postRequest(for: signUpURL)

        do {
            let jsonData = try JSONEncoder().encode(user)
            print(String(data: jsonData, encoding: .utf8)!)
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
                if let error = error {
                    print("Sign Up failed due to Error: \(error)")
                    completion(.failure(.failedSignUP))
                    return
                }

                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("SignUp was unsuccessful")
                        completion(.failure(.failedSignUP))
                        return
                }
                completion(.success(true))
            }
            task.resume()
        } catch {
            print("Error encoding user: \(error)")
            completion(.failure(.failedSignUP))
        }
    }

    private func postRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }

    func signIn(with user: User, completion: @escaping (Result<Bool, NetWorkError>) -> Void) {
        print("SignInURL = \(signInURL.absoluteString)")
        var request = postRequest(for: signInURL)

        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("SignIn in failed with error \(error)")
                    completion(.failure(.failedSignIn))
                    return
                }

                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("Sign in was unsuccessful")
                        completion(.failure(.failedSignIn))
                        return
                }

                guard let data = data else {
                    print("Data was not recieved")
                    completion(.failure(.noData))
                    return
                }

                do {
                    self.bearer = try JSONDecoder().decode(Bearer.self, from: data)
                    completion(.success(true))
                } catch {
                    print("Error decoding bearer: \(error)")
                    completion(.failure(.noToKen))
                    return
                }
            }
            task.resume()
        } catch {
            print("Error encoding user: \(error.localizedDescription)")
            completion(.failure(.failedSignIn))
        }
    }

    func fetchAllGigs(completion: @escaping (Result<[Gig], NetWorkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noToKen))
            return
        }

        var request = URLRequest(url: allGigURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error receiving animal name data: \(error)")
                completion(.failure(.sessionTryAgian))
            }

            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.noToKen))
                return
            }

            guard let data = data else {
                print("No data was received from All Gigs")
                completion(.failure(.noData))
                return
            }

            do {
                let gigTitles = try JSONDecoder().decode([Gig].self, from: data)
                self.gigs = gigTitles
                completion(.success(gigTitles))
            } catch {
                print("Error decoding Gig Title data: \(error)")
                completion(.failure(.sessionTryAgian))
            }
        }
        task.resume()
    }

    func postGigDetail(with gig: Gig, completion: @escaping (Result<Gig, NetWorkError>) ->Void) {
        guard let bearer = bearer else {
            completion(.failure(.noToKen)) // my key access the API
            return
        }

//      var postrequest = baseURL.appendingPathComponent("gigs") example on how to use appendingPathComponent
        var request = URLRequest(url: allGigURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // me tell the API this of type JSON
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization") // Me showing the API I have a authiticated key

        let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                print("Error reciveing due to post having error: \(error)")
                completion(.failure(.sessionTryAgian))
            }

            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.noToKen))
                return
            }

            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601

                let jsonGig = try JSONEncoder().encode(gig)
                request.httpBody = jsonGig
            } catch {
                print("Error encoding user: \(error)")
                completion(.failure(.failToPost))
            }
        }
        task.resume()
    }

}
