//
//  GigsTableViewController.swift
//  ios-gigs
//
//  Created by Ryan Murphy on 5/16/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
var gigController = GigController()
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginScreen", sender: self)
        } else { gigController.fetchGigs { (result) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
    }
        }
    }
    
    // MARK: - Table view data source
    // learning to delete #of sections when I don't need it ...

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobCell", for: indexPath)
        let gig = gigController.gigs[indexPath.row]
        let formatter = DateFormatter()
        
        
        
        cell.textLabel?.text = gig.title
        cell.detailTextLabel?.text = "\(formatter.string(from: gig.dueDate))"
        // Configure the cell...
       
        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginScreen" {
            guard let destinationVC = segue.destination as? LoginViewController else { return }
            destinationVC.gigController = gigController
        }
        
        if segue.identifier == "FromCell" {
            guard let destinationVC = segue.destination as? JobDetailViewController else { return }
            destinationVC.gigController = gigController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            destinationVC.gig = gigController.gigs[indexPath.row]
        }
        
        if segue.identifier == "FromAdd" {
            guard let destinationVC = segue.destination as? JobDetailViewController else { return }
            destinationVC.gigController = gigController
        }
    }







    

}

