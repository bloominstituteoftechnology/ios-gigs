//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Zack Larsen on 12/4/19.
//  Copyright © 2019 Zack Larsen. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
            
            // TODO: fetch gigs here
            
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
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        let gig = gigController.gigs[indexPath.row]
        
        cell.textLabel?.text = gig.title
        
        cell.detailTextLabel?.text = "Due \(dateFormatter.string(from: gig.dueDate))"
        return cell
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        
        // Set segue identifier or which segue.
        if segue.identifier == "LoginViewModalSegue" {
            
            // Set a destination
            // Cast the destination as where we're going i.e. to which viewController
            guard let destination = segue.destination as? LoginViewController else { return }
            
           
            // Pass what we need in the viewController
            destination.gigController = gigController
        } else if segue.identifier == "ShowGigDetail" {
            
            guard let destination = segue.destination as? GigDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            let gig = gigController.gigs[indexPath.row]
            
            destination.gigController = gigController
            destination.gig = gig
            
        } else if segue.identifier == "CreateGig" {
            guard let destination = segue.destination as? GigDetailViewController
                else { return }
            
            destination.gigController = gigController
        }
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
        
        return formatter
    }()
    
 let gigController = GigController()
}
