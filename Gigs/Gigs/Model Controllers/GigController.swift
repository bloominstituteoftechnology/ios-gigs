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

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
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
//
//    func fetchAllAnimalNames(completion: @escaping (Result<[String], NetworkError>) -> Void) {
//        guard let bearer = bearer else {
//            completion(.failure(.noAuth))
//            return
//        }
//
//        let allAnimalsUrl = baseUrl.appendingPathComponent("animals/all")
//
//        var request = URLRequest(url: allAnimalsUrl)
//        request.httpMethod = HTTPMethod.get.rawValue
//        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let response = response as? HTTPURLResponse,
//                response.statusCode == 401 {
//                completion(.failure(.badAuth))
//                return
//            }
//
//            if let _ = error {
//                completion(.failure(.otherError))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(.badData))
//                return
//            }
//
//            let decoder = JSONDecoder()
//            do {
//                let animalNames = try decoder.decode([String].self, from: data)
//                completion(.success(animalNames))
//            } catch {
//                print("Error decoding animal objects: \(error)")
//                completion(.failure(.noDecode))
//                return
//            }
//            }.resume()
//    }
//
//    func fetchDetails(for animalName: String, completion: @escaping (Result<Animal, NetworkError>) -> Void) {
//        guard let bearer = bearer else {
//            completion(.failure(.noAuth))
//            return
//        }
//
//        let animalUrl = baseUrl.appendingPathComponent("animals/\(animalName)")
//
//        var request = URLRequest(url: animalUrl)
//        request.httpMethod = HTTPMethod.get.rawValue
//        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let response = response as? HTTPURLResponse,
//                response.statusCode == 401 {
//                completion(.failure(.badAuth))
//                return
//            }
//
//            if let _ = error {
//                completion(.failure(.otherError))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(.badData))
//                return
//            }
//
//            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .secondsSince1970
//            do {
//                let animal = try decoder.decode(Animal.self, from: data)
//                completion(.success(animal))
//            } catch {
//                print("Error decoding animal object: \(error)")
//                completion(.failure(.noDecode))
//                return
//            }
//            }.resume()
//    }
//
//    func fetchImage(at urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
//        let imageUrl = URL(string: urlString)!
//
//        var request = URLRequest(url: imageUrl)
//        request.httpMethod = HTTPMethod.get.rawValue
//
//        URLSession.shared.dataTask(with: request) { (data, _, error) in
//            if let _ = error {
//                completion(.failure(.otherError))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(.badData))
//                return
//            }
//
//            let image = UIImage(data: data)!
//            completion(.success(image))
//            }.resume()
//    }
//}
    
}
