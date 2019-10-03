//
//  GigsTableViewController.swift
//  ios-Gigs
//
//  Created by Gi Pyo Kim on 10/2/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    // MARK: - Properties
    var gigController = GigController()
    let formatter = DateFormatter()
    
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        } else {
            gigController.fetchAllGigs { (result) in
                do {
                    try result.get()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                } catch {
                    NSLog("Error fetching all gigs: \(error)")
                }
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        cell.detailTextLabel?.text = formatter.string(from: gigController.gigs[indexPath.row].dueDate)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        } else if segue.identifier == "ViewGigSegue" {
            if let gigDetailVC = segue.destination as? GigDetailViewController, let indexPath = tableView.indexPathForSelectedRow {
                gigDetailVC.gigController = gigController
                gigDetailVC.gig = gigController.gigs[indexPath.row]
            }
        } else if segue.identifier == "AddGigSegue"{
            if let gigDetailVC = segue.destination as? GigDetailViewController {
                gigDetailVC.gigController = gigController            }
        }
        
    }
}
