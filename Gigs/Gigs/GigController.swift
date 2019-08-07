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

class GigController {
	
	private(set) var bearer: Bearer?
	let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
	
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
		
		URLSession.shared.dataTask(with: request) { (_, response, error) in
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
	
	func loginUser(username: String, password: String, completion: @escaping (Error?) -> Void) {
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
		
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			if let response = response as? HTTPURLResponse, response.statusCode != 200 {
				NSLog("Error: status code is \(response.statusCode) instead of 200.")
			}
			if let error = error {
				NSLog("Error creating user: \(error)")
				completion(error)
				return
			}
			guard let data = data else {
				NSLog("No data was returned")
				completion(NSError())
				return
			}
			
			do {
				let bearer = try JSONDecoder().decode(Bearer.self, from: data)
				self.bearer = bearer
			} catch {
				NSLog("Error decoding bearer: \(error)")
				completion(error)
				return
			}
			completion(nil)
		}.resume()
	}
}
