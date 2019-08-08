//
//  GigController.swift
//  Gigs
//
//  Created by Jeffrey Santana on 8/7/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
	case get = "GET"
	case put = "PUT"
	case post = "POST"
	case delete = "DELETE"
}

enum NetworkError: Error {
	case badURL
	case noToken
	case noData
	case notDecoding
	case other(Error)
}

class GigController {
	
	private(set) var bearer: Bearer?
	private(set) var gigs = [Gig]()
	private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
	private let session = URLSession.shared
	
	func createUser(username: String, password: String, completion: @escaping (Error?) -> Void) {
		let user = User(username: username, password: password)
		let signupURL = baseURL.appendingPathComponent("users/signup")
		var request = URLRequest(url: signupURL)
		
		request.httpMethod = HTTPMethod.post.rawValue
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		do {
			let userData = try JSONEncoder().encode(user)
			request.httpBody = userData
		} catch {
			NSLog("Trouble encoding user: \(error)")
		}
		
		session.dataTask(with: request) { (_, response, error) in
			if let response = response as? HTTPURLResponse, response.statusCode != 200 {
				NSLog("Error: status code is \(response.statusCode) instead of 200.")
			}
			if let error = error {
				NSLog("Error creating user: \(error)")
				completion(error)
				return
			}
			completion(nil)
		}.resume()
	}
	
	func loginUser(username: String, password: String, completion: @escaping (Result<String?, NetworkError>) -> Void) {
		let user = User(username: username, password: password)
		let loginURL = baseURL.appendingPathComponent("users/login")
		var request = URLRequest(url: loginURL)
		
		request.httpMethod = HTTPMethod.post.rawValue
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		do {
			let userData = try JSONEncoder().encode(user)
			request.httpBody = userData
		} catch {
			NSLog("Trouble encoding user: \(error)")
		}
		
		session.dataTask(with: request) { (data, response, error) in
			if let response = response as? HTTPURLResponse, response.statusCode != 200 {
				NSLog("Error: status code is \(response.statusCode) instead of 200.")
			}
			
			if let error = error {
				NSLog("Error creating user: \(error)")
				completion(.failure(.other(error)))
				return
			}
			
			guard let data = data else {
				NSLog("No data was returned")
				completion(.failure(.noData))
				return
			}
			
			do {
				let bearer = try JSONDecoder().decode(Bearer.self, from: data)
				self.bearer = bearer
				completion(.success(nil))
			} catch {
				NSLog("Error decoding bearer: \(error)")
				completion(.failure(.notDecoding))
				return
			}
		}.resume()
	}
	
	func getAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
		guard let token = bearer?.token else {
			completion(.failure(.noToken))
			return
		}
		let gigsURL = baseURL.appendingPathComponent("gigs")
		var request = URLRequest(url: gigsURL)
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		session.dataTask(with: request) { (data, response, error) in
			if let error = error {
				if let response = response as? HTTPURLResponse, response.statusCode != 200 {
					NSLog("Error: status code is \(response.statusCode) instead of 200.")
				}
				NSLog("Error creating user: \(error)")
				completion(.failure(.other(error)))
				return
			}
			
			guard let data = data else {
				NSLog("No data was returned")
				completion(.failure(.noData))
				return
			}
			
			do {
				let decoder = JSONDecoder()
				decoder.dateDecodingStrategy = .iso8601
				
				let gigs = try decoder.decode([Gig].self, from: data)
				self.gigs = gigs
				completion(.success(gigs))
			} catch {
				completion(.failure(.notDecoding))
			}
		}.resume()
	}
}
