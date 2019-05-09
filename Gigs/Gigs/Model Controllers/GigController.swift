//
//  GigController.swift
//  Gigs
//
//  Created by Lisa Sampson on 5/9/19.
//  Copyright © 2019 Lisa M Sampson. All rights reserved.
//

import Foundation

class GigController {
    
    // MARK: - Properties
    
    var gigs: [Gig] = []
    var bearer: Bearer?
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api/")!
    
    
    // MARK: - Create and Fetch Gigs
    
    func fetchAllGigs(completion: @escaping (Error?) -> Void) {
        guard let bearer = bearer else {
            completion(NSError())
            return
        }
        
        let gigsURL = baseURL.appendingPathComponent("/gigs/")
        
        var request = URLRequest(url: gigsURL)
        request.httpMethod = "GET"
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(error)
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
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                self.gigs = try decoder.decode([Gig].self, from: data)
                completion(nil)
            } catch {
                NSLog("Error decoding animal object: \(error)")
                completion(error)
                return
            }
            }.resume()
    }
    
    func createGig(with gig: Gig, completion: @escaping (Error?) -> Void) {
        guard let bearer = bearer else {
            completion(NSError())
            return
        }
        
        let gigsURL = baseURL.appendingPathComponent("/gigs/")
        
        var request = URLRequest(url: gigsURL)
        request.httpMethod = "GET"
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.dateEncodingStrategy = .iso8601
            request.httpBody = try jsonEncoder.encode(gig)
        } catch {
            NSLog("Error encoding gig object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            self.gigs.append(gig)
            }.resume()
        }
    
}
