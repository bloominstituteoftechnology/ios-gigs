//
//  GigController.swift
//  Gigs
//
//  Created by Michael Redig on 5/9/19.
//  Copyright © 2019 Michael Redig. All rights reserved.
//

import Foundation


class GigController {

	let networkManager = MahDataGetter()

	var gigs: [Gig] = []
	var bearer: Bearer?

	enum Endpoints: String {
		case signup = "/users/signup"
		case login = "/users/login"
		case gigs = "/gigs"
	}

	enum HTTPHeaderKeys: String {
		case contentType = "Content-Type"
		case auth = "Authorization"

		enum ContentTypes: String {
			case json = "application/json"
		}
	}
	

	let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!

	func signUp(with user: User, completion: @escaping (Error?)->Void) {
		let signUpURL = baseURL.appendingPathComponent(Endpoints.signup.rawValue)

		var request = URLRequest(url: signUpURL)
		request.httpMethod = HTTPMethods.post.rawValue
		request.addValue(HTTPHeaderKeys.ContentTypes.json.rawValue, forHTTPHeaderField: HTTPHeaderKeys.contentType.rawValue)

		let encoder = JSONEncoder()
		do {
			request.httpBody = try encoder.encode(user)
		} catch {
			completion(error)
			return
		}

		networkManager.fetchMahDatas(with: request) { (_, _, error) in
			if let error = error {
				completion(error)
			} else {
				completion(nil)
			}
		}
	}

	func login(with user: User, completion: @escaping (Error?)->Void) {
		let loginURL = baseURL.appendingPathComponent(Endpoints.login.rawValue)

		var request = URLRequest(url: loginURL)
		request.httpMethod = HTTPMethods.post.rawValue
		request.addValue(HTTPHeaderKeys.ContentTypes.json.rawValue, forHTTPHeaderField: HTTPHeaderKeys.contentType.rawValue)

		let encoder = JSONEncoder()
		do {
			request.httpBody = try encoder.encode(user)
		} catch {
			completion(error)
			return
		}

		networkManager.fetchMahDatas(with: request) { (_, data, error) in
			if let error = error {
				completion(error)
				return
			}

			guard let data = data else {
				completion(MahDataGetter.NetworkError.badData)
				return
			}

			let decoder = JSONDecoder()
			do {
				self.bearer = try decoder.decode(Bearer.self, from: data)
				completion(nil)
			} catch {
				completion(error)
			}
		}
	}

	func getAllGigs(completion: @escaping (Error?)->Void) {
		guard let bearer = bearer else { return }
		let gigsURL = baseURL.appendingPathComponent(Endpoints.gigs.rawValue)

		var request = URLRequest(url: gigsURL)
		request.httpMethod = HTTPMethods.get.rawValue
		request.addValue(bearer.token, forHTTPHeaderField: HTTPHeaderKeys.auth.rawValue)

		networkManager.fetchMahDatas(with: request) { (_, data, error) in
			if let error = error {
				completion(error)
			}

			guard let data = data else {
				completion(MahDataGetter.NetworkError.badData)
				return
			}

			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601

			do {
				let gigsArray = try decoder.decode([Gig].self, from: data)
				self.gigs = gigsArray
				completion(nil)
			} catch {
				completion(error)
			}
		}
	}

	func createAGig(gig: Gig, completion: @escaping (Error?)->Void) {
		guard let bearer = bearer else { return }

		let gigsURL = baseURL.appendingPathComponent(Endpoints.gigs.rawValue)

		var request = URLRequest(url: gigsURL)
		request.httpMethod = HTTPMethods.post.rawValue
		request.addValue(bearer.token, forHTTPHeaderField: HTTPHeaderKeys.auth.rawValue)

		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .iso8601
		do {
			let jsonData = try encoder.encode(gig)
			request.httpBody = jsonData
		} catch {
			completion(error)
			return
		}

		networkManager.fetchMahDatas(with: request) { (_, data, error) in
			if let error = error {
				completion(error)
				return
			}

			self.gigs.append(gig)
			completion(nil)
		}
	}
}
