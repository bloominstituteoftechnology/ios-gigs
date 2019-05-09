//
//  GigController.swift
//  gigs
//
//  Created by Hector Steven on 5/9/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import Foundation



class GigController {

	func signUp(with user: User, completion: @escaping (Error?) -> ()) {
		let url = baseURL.appendingPathComponent("users/signup")
		
		var request = URLRequest(url: url)
		request.httpMethod = HTTPMethod.post.rawValue
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		let encoder = JSONEncoder()
		do {
			let jsonData = try encoder.encode(user)
			request.httpBody = jsonData
		} catch {
			print("Error encoding user objects: \(error)")
		}
		
		URLSession.shared.dataTask(with: request) {
			_, response, error in
			
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
	
	func signIn(user: User, completion: @escaping (Error?) -> ()) {
		let url = baseURL.appendingPathComponent("users/login")
		var request = URLRequest(url: url)
		request.httpMethod = HTTPMethod.post.rawValue
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		
		let encoder = JSONEncoder()
		do {
			let jsonData = try encoder.encode(user)
			request.httpBody = jsonData
		} catch {
			print("error encoding user object\(error)")
			completion(error)
			return
		}
		
		URLSession.shared.dataTask(with: request) {
			data, response, error in
			
			if let response = response as? HTTPURLResponse,
				response.statusCode != 200 {
				completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
				return
			}
			
			if let _ = error {
				completion(NSError())
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
				print("error decoding bearrer object: \(error)")
				completion(error)
				return
			}
		}.resume()
	}
	
	func fetchDetails(for animalName: String, completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
		guard let bearer = bearer else {
			completion(.failure(.noAuth))
			return
		}
		
		let url = baseURL.appendingPathComponent("gigs")
		
		var request = URLRequest(url: url)
		request.httpMethod = HTTPMethod.get.rawValue
		request.addValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")
		
		URLSession.shared.dataTask(with: request) {
			data, response, error in
			
			if let response = response as? HTTPURLResponse,
				response.statusCode != 200 {
				completion(.failure(.badAuth))
				return
			}
			
			if let _ = error {
				completion(.failure(.otherError))
			}
			
			guard let data = data else {
				completion(.failure(.badData))
				return
			}
			
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601

			do {
				let gigs = try decoder.decode([Gig].self, from: data)
				completion(.success(gigs))
			} catch {
				print("Error decoding animal object: \(error)")
				completion(.failure(.noDecode))
			}
		}.resume()
	}

	private(set) var gigs: [Gig] = []
	var bearer: Bearer?
	private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
}
