//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Jeremy Taylor on 5/16/19.
//  Copyright © 2019 Bytes-Random L.L.C. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    let gigController = GigController()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: "SignInSignUpSegue", sender: self)
        } else {
            gigController.getAllGigs { (error) in
                if let error = error {
                    NSLog("Error fetching gigs: \(error)")
                    return
                }
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        cell.textLabel?.text = gig.title
        cell.detailTextLabel?.text = "Due: \(dateFormatter.string(from: gig.dueDate))"

        return cell
    }
    
    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignInSignUpSegue" {
            guard let loginVC = segue.destination as? LoginViewController else { return }
            loginVC.gigController = gigController
            
        } else if segue.identifier == "AddGig" {
            guard let detailVC = segue.destination as? GigDetailViewController else { return }
            detailVC.gigController = gigController
            
        } else if segue.identifier == "ShowGig" {
            guard let detailVC = segue.destination as? GigDetailViewController else { return }
            detailVC.gigController = gigController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            detailVC.gig = gigController.gigs[indexPath.row]
        }
    }
    

}
