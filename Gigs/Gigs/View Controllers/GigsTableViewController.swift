//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Dennis Rudolph on 10/30/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    let gigController = GigController()
    
    var df: DateFormatter {
        let dF = DateFormatter()
        dF.dateStyle = .short
        return dF
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LogSignSegue", sender: self)
        } else {
            getGigs()
        }
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return gigController.gigs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        
        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        cell.detailTextLabel?.text = df.string(from: gigController.gigs[indexPath.row].dueDate)
        
        return cell
    }
    
    func getGigs() {
        gigController.fetchAllGigs { result in
            do {
                let theGigs = try result.get()
                DispatchQueue.main.async {
                    self.gigController.gigs = theGigs
                    self.tableView.reloadData()
                }
            } catch {
                if let error = error as? NetworkError {
                    switch error {
                    case .noAuth:
                        print("No bearer token exists")
                    case .badAuth:
                        print("Bearer token invalid")
                    case .otherError:
                        print("Other error occurred, see log")
                    case .badData:
                        print("No data received, or data corrupted")
                    case .noDecode:
                        print("JSON could not be decoded")
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LogSignSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        } else if segue.identifier == "AddSegue" {
            if let detailVC = segue.destination as? GigDetailViewController {
                detailVC.gigController = gigController
            }
        } else if segue.identifier == "GigSegue" {
            if let indexPath = tableView.indexPathForSelectedRow,
                let detailVC = segue.destination as? GigDetailViewController {
                detailVC.gigController = gigController
                detailVC.gig = gigController.gigs[indexPath.row]
            }
        }
    }
}
