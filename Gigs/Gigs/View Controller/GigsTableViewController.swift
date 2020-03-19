//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Matthew Martindale on 3/14/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    let gigController = GigController()
    var gigs: [Gig] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginSegue", sender: self)
        } else {
            gigController.fetchAllGigs { result in
                do {
                    let gigs = try result.get()
                    DispatchQueue.main.async {
                        self.gigs = gigs
                    }
                } catch {
                    if let error = error as? NetworkError {
                        switch error {
                        case .noAuth:
                            print("Error: No bearer token exists")
                        case .badAuth:
                            print("Error: Bearer token invalid")
                        case .noData:
                            print("Error: No data")
                        case .decodeFailure:
                            print("Error: Decode failure")
                        case .otherError(let otherError):
                            print("Error: \(otherError)")
                        }
                    } else {
                        print("Error: \(error)")
                    }
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigsCell", for: indexPath)
        cell.textLabel?.text = gigs[indexPath.row].title
        cell.detailTextLabel?.text = "Due: \(gigs[indexPath.row].dueDate)"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginSegue" {
            let loginVC = segue.destination as? LoginViewController
            loginVC?.gigController = gigController
        }
    }

}
