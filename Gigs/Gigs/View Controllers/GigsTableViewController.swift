//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Elizabeth Thomas on 3/17/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    
    // MARK: - Public Properties
    let gigController = GigController()
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    var gigs: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Life Cycles
    override func viewDidAppear(_ animated: Bool) {
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginSegue", sender: self)
        } else {
            gigController.fetchAllGigs { (result) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
       // TODO: fetch gigs here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gigController.fetchAllGigs { (result) in
            do {
                let gigs = try result.get()
                DispatchQueue.main.async {
                    self.gigs = gigs
                }
            } catch {
                if let error = error as? NetworkError {
                    switch error {
                    case .noAuth:
                        print("Error: No bearer token exists.")
                    case .unauthorized:
                        print("Error: Bearer token invalid.")
                    case .noData:
                        print("Error: The response had no data.")
                    case .decodeFailed:
                        print("Error: The data could not be decoded.")
                    case .encodeFailed:
                        print("Error: The data could not be encoded.")
                    case .otherError(let otherError):
                        print("Error: \(otherError)")
                    }
                } else {
                    print("Error: \(error)")
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        
        let gig = gigController.gigs[indexPath.row]
        cell.textLabel?.text = gig.title
        cell.detailTextLabel?.text = "Due" + " " + dateFormatter.string(from: gig.dueDate)
   
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginSegue",
            let loginVC = segue.destination as? LoginViewController {
            loginVC.gigController = gigController
        } else if segue.identifier == "AddGigSegue",
            let addGigVC = segue.destination as? GigDetailViewController {
            addGigVC.gigController = gigController
        } else if segue.identifier == "GigDetailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow,
                let gigDetailVC = segue.destination as? GigDetailViewController {
                let gig = gigController.gigs[indexPath.row]
                gigDetailVC.gig = gig
                gigDetailVC.gigController = gigController
            }
        }
    }
}
