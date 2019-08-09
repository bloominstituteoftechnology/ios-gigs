//
//  GigController.swift
//  Gigs
//
//  Created by Taylor Lyles on 8/7/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
}

class GigController {
	
	var bearer: Bearer?
	var gigs: [Gig] = []
	
	private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
	
	func signUp(with user: User, completion: @escaping (Error?) -> (Void)) {
		let signUpURL = baseURL
			.appendingPathComponent("users")
			.appendingPathComponent("signup")
		
		var request = URLRequest(url: signUpURL)
		request.httpMethod = HTTPMethod.post.rawValue
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		do {
			request.httpBody = try JSONEncoder().encode(user)
		} catch {
			NSLog("Error encoding user object: \(error)")
			completion(error)
			return
		}
		
		URLSession.shared.dataTask(with: request) { (_, response, error) in
			if let response =  response as? HTTPURLResponse,
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
	
	func logIn(with user: User, completion: @escaping (Error?) -> ()) {
		let logInUrl = baseURL
			.appendingPathComponent("users")
			.appendingPathComponent("login")
		
		var request = URLRequest(url: logInUrl)
		request.httpMethod = HTTPMethod.post.rawValue
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		do {
			request.httpBody = try JSONEncoder().encode(user)
		} catch {
			NSLog("Error encoding user object: \(error)")
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
				completion(NSError(domain: "No data recieved", code: -1, userInfo: nil))
				return
			}
			
			do {
				let bearer = try JSONDecoder().decode(Bearer.self, from: data)
				self.bearer = bearer
				completion(nil)
			} catch {
				NSLog("Token not recieved: \(error)")
				completion(error)
				return
			}
		}.resume()
	}
	
	func gettingGigs(completion: @escaping (Error?) -> Void) {
		
		guard let bearer = bearer else {
			completion(NSError(domain: "No bearer", code: -1, userInfo: nil))
			return
		}
		
		let gigURL = baseURL.appendingPathComponent("gigs")
		
		var request = URLRequest(url: gigURL)
		request.httpMethod = HTTPMethod.get.rawValue
		request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
		
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			if let response = response as? HTTPURLResponse,
				response.statusCode != 200 {
				completion(NSError(domain: "Status code is not 200", code: -2, userInfo: nil))
				return
			}
			
			if let error = error {
				completion(error)
			}
			guard let data = data else {
				completion(error)
				return
			}
			
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601
			
			do {
				let allGig = try decoder.decode([Gig].self, from: data)
				self.gigs = allGig
				completion(nil)
			} catch {
				NSLog("Error decoding: \(error)")
				completion(error)
				return
			}
			
		}.resume()
	}
	
	func createGig(title: String, description: String, dueDate: Date, completion: @escaping (Error?) -> Void) {
		
		guard let bearer = bearer else {
			completion(NSError(domain: "No bearer", code: -1, userInfo: nil))
			return
		}
		
		let gig = Gig(title: title, description: description, dueDate: dueDate)
		
		let newGigURL = baseURL.appendingPathComponent("gigs")
		
		var request = URLRequest(url: newGigURL)
		request.httpMethod = HTTPMethod.post.rawValue
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
		
		do {
			let encoder = JSONEncoder()
			encoder.dateEncodingStrategy = .iso8601
			request.httpBody = try encoder.encode(gig)
		} catch {
			completion(error)
			return
		}
		
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			if let response = response as? HTTPURLResponse,
				response.statusCode != 200 {
				completion(NSError(domain: "Status code is not 200", code: -2, userInfo: nil))
				return
			}
			
			if let error = error {
				completion(error)
				return
			}
			
			self.gigs.append(gig)
			completion(nil)
			
		}.resume()
		
		
		
	}
}
