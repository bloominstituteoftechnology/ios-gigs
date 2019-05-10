//
//  MahDataGetter.swift
//  iTunes Searcher
//
//  Created by Michael Redig on 5/7/19.
//  Copyright © 2019 Michael Redig. All rights reserved.
//
//swiftlint:disable line_length

import Foundation

class MahDataGetter {

	enum HTTPMethods: String {
		case post = "POST"
		case put = "PUT"
		case delete = "DELETE"
	}

	enum NetworkError: Error {
		case noAuth
//		case badAuth
		case otherError
		case badData
		case noDecode
		case httpNon200StatusCode(code: Int)
	}


	func fetchMahDatas(with request: URLRequest, requestID: String? = nil, completion: @escaping (String?, Data?, Error?) -> Void) {
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			if let response = response as? HTTPURLResponse, response.statusCode != 200 {
				print("non 200 http response: \(response.statusCode)")
				let myError = NetworkError.httpNon200StatusCode(code: response.statusCode)
				completion(requestID, nil, myError)
				return
			}

			if let error = error {
				print("error getting url '\(request.url ?? URL(string: "")!)': \(error)")
				completion(requestID, nil, error)
				return
			}

			let dataError = data != nil ? nil : NetworkError.badData
			completion(requestID, data, dataError)
		}.resume()
	}

//	func pushMahDatas(with request: URLRequest, )
}
