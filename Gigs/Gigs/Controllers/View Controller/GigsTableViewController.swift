//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Tobi Kuyoro on 15/01/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    let gigController = GigController()
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LogInModalSegue", sender: self)
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
        dateFormatter.string(from: gig.dueDate)
        
        cell.textLabel?.text = gig.title
        cell.detailTextLabel?.text = "Due \(gig.dueDate)"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LogInModalSegue" {
            if let destinationVC = segue.destination as? LoginViewController {
                destinationVC.gigController = gigController
            }
        }
        
        else if segue.identifier == "AddGigShowSegue" {
            if let createNewGigVC = segue.destination as? GigDetailViewController {
                createNewGigVC.gigController = gigController
            }
        }
        
        else if segue.identifier == "ViewGigShowSegue" {
            if let viewNewGigVC = segue.destination as? GigDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                let gig = gigController.gigs[indexPath.row]
                viewNewGigVC.gig = gig
            }
        }
    }
}
