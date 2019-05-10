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
		print(request)
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
		print(request)
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
			completion(nil)
		}.resume()
	}
	
	func fetchGigs(completion: @escaping (Error?) -> ()) {
		guard let bearer = bearer else {
			completion(NSError())
			return
		}
		
		let url = baseURL.appendingPathComponent("gigs")
		
		var request = URLRequest(url: url)
		request.httpMethod = HTTPMethod.get.rawValue
		request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
		print(request)
		
		URLSession.shared.dataTask(with: request) {
			data, response, error in
			
			if let response = response as? HTTPURLResponse,
				response.statusCode == 401 {
				completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
				return
			}
			
			if let error = error {
				completion(error)
			}
			
			guard let data = data else {
				completion(nil)
				return
			}
			
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601

			do {
				let decodedGigs = try decoder.decode([Gig].self, from: data)
				self.gigs = decodedGigs.sorted {$0.title < $1.title }
			} catch {
				print("Error decoding gig object: \(error)")
				completion(error)
			}
			completion(nil)
		}.resume()
	}

	func creatGig(gig: Gig, completion: @escaping (Error?) -> ()) {
		guard let bearer = bearer else { return }
		let url = baseURL.appendingPathComponent("gigs")
		
		var request = URLRequest(url: url)
		request.httpMethod = HTTPMethod.post.rawValue
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
	
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .iso8601
		do {
			request.httpBody = try encoder.encode(gig)
		} catch {
			print("error encoding gig object: \(error)")
			completion(error)
			return
		}

		URLSession.shared.dataTask(with: request) { _, response, error in
			
			if let response = response as? HTTPURLResponse,
				response.statusCode != 200{
				
				print("response creating a gig: ", response.statusCode)
				completion(nil)
				return
			}
			
			if let error = error {
				print("error entering dataTask: \(error)")
				completion(NSError())
				return
			}
			
			self.gigs.append(gig)
			completion(nil)
		}.resume()
	}
	
	func isDuplicate(newgig: Gig) -> Bool{
		for gig in gigs {
			if gig.title  == newgig.title {
				return true
			}
		}
		return false
	}
	

	private(set) var gigs: [Gig] = []
	var bearer: Bearer?
	private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
}
