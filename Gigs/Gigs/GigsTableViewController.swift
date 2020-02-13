//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Tobi Kuyoro on 12/02/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    let gigController = GigController()
    let dateFormatter = DateFormatter()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginModalSegue", sender: self)
        } else {
            gigController.getAllGigs { (result) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let date = dateFormatter.string(from: gig.dueDate)
        
        cell.textLabel?.text = gig.title
        cell.detailTextLabel?.text = date

        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        }
        
        else if segue.identifier == "GigDetailShowSegue" {
            if let gigDetailVC = segue.destination as? GigDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                let gig = gigController.gigs[indexPath.row]
                gigDetailVC.gig = gig
                gigDetailVC.gigController = gigController
            }
        }
        
        else if segue.identifier == "AddGigShowSegue" {
            if let addGigVC = segue.destination as? GigDetailViewController {
                addGigVC.gigController = gigController
            }
        }
    }
}
