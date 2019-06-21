//
//  GigController.swift
//  Gigs
//
//  Created by Marlon Raskin on 6/19/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
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

class GigController: Codable {
	
	var gigs: [Gig] = []
	
	func df(date: Date) -> String {
		let df = DateFormatter()
		df.dateStyle = .short
		return df.string(from: date)
	}
	
	var bearer: Bearer?
	private let baseUrl = URL(string: "https://lambdagigs.vapor.cloud/api")!
	
	//Function for signing up
	func signUp(with user: User, completion: @escaping (Error?) -> ()) {
		let signUpUrl = baseUrl.appendingPathComponent("users/signup")
		
		var request = URLRequest(url: signUpUrl)
		request.httpMethod = HTTPMethod.post.rawValue
		request.setValue("application/json", forHTTPHeaderField: "Content-Type") //What is this doing????????
		
		let jsonEncoder = JSONEncoder()
		do {
			let jsonData = try jsonEncoder.encode(user)
			request.httpBody = jsonData
		} catch {
			print("Error encoding user object: \(error)")
			completion(error)
			return
		}
		
		URLSession.shared.dataTask(with: request) { _, response, error in
			if let response = response as? HTTPURLResponse,
				response.statusCode != 200 {
				completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
				return
			}
			
			if let error = error { //Ask Conner to make sense of this! ???????
				completion(error)
				return
			}
			
			completion(nil)
		}.resume()
	}
	
	//Function for signinig in
	func signIn(with user: User, completion: @escaping (Error?) -> ()) {
		let signInUrl = baseUrl.appendingPathComponent("users/login")
		
		var request = URLRequest(url: signInUrl)
		request.httpMethod = HTTPMethod.post.rawValue //Why POST instead of GET ???????
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
				completion(NSError()) //WHY use NSError here??????????
				return
			}
			
			let decoder = JSONDecoder() //Why is decoding done under URLSession??????
			do {
				self.bearer = try decoder.decode(Bearer.self, from: data)

			} catch {
				completion(error)
				return
			}
			
			completion(nil)
		}.resume()
	}
	
	// Function for fetching all Gigs
	func fetchAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
		guard let bearer = bearer else {
			completion(.failure(.noAuth))
			return
		}
		
		let allGigsUrl = baseUrl.appendingPathComponent("gigs")
		var request = URLRequest(url: allGigsUrl)
		request.httpMethod = HTTPMethod.get.rawValue
		request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
		
		URLSession.shared.dataTask(with: request) { data, response, error in
			if let response = response as? HTTPURLResponse,
				response.statusCode == 401 {
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
				self.gigs = try decoder.decode([Gig].self, from: data)
				completion(.success(self.gigs))
			} catch {
				completion(.failure(.noDecode))
				return
			}
		}.resume()
	}
	
	//Function for fetching details
	func fetchGigDetails(for gig: String, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
		guard let bearer = bearer else {
			completion(.failure(.noAuth))
			return
		}
		
		let gigUrl = baseUrl.appendingPathComponent("gigs/\(gig)")
		var request = URLRequest(url: gigUrl)
		request.httpMethod = HTTPMethod.get.rawValue
		request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
		
		URLSession.shared.dataTask(with: request) { data, response, error in
			if let response = response as? HTTPURLResponse,
				response.statusCode == 401 {
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
				let gig = try decoder.decode(Gig.self, from: data)
				completion(.success(gig))
			} catch {
				completion(.failure(.noDecode))
				return
			}
		}.resume()
	}
	
	//Function for creating a gig and adding details to server
	func createGig(for gigTitle: String, gigDescription: String, gigDate: Date, completion: @escaping (Error?) -> ()) {
		let gig = Gig(title: gigTitle, description: gigDescription, dueDate: gigDate)
		let createGigUrl = baseUrl.appendingPathComponent("gigs")
		
		var request = URLRequest(url: createGigUrl)
		request.httpMethod = HTTPMethod.post.rawValue
		request.addValue("application", forHTTPHeaderField: "Content-Type")
		
		let jsonEncoder = JSONEncoder()
		do {
			let jsonData = try jsonEncoder.encode(gig)
			request.httpBody = jsonData
		} catch {
			print("Error encoding gig object: \(error)")
			completion(error)
			return
		}
		
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
			self.gigs.append(gig)
			completion(nil)
		}.resume()
	}
}
