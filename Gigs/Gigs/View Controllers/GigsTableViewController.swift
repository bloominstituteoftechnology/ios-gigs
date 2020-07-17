//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Eoin Lavery on 13/07/2020.
//  Copyright © 2020 Eoin Lavery. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    var gigController = GigController()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        if gigController.bearer == nil {
            self.performSegue(withIdentifier: "LoginSignupModalSegue", sender: nil)
        } else {
            gigController.getAllGigs { (error) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gigController.gigs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let gigCell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)

        let currentGig = gigController.gigs[indexPath.row]
        gigCell.textLabel?.text = currentGig.title
        gigCell.detailTextLabel?.text = ("Due Date: \(dateFormatter.string(from: currentGig.dueDate))")
        
        return gigCell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginSignupModalSegue" {
            if let destinationVC = segue.destination as? LoginViewController {
                destinationVC.gigController = gigController
            }
        }
        
        if segue.identifier == "AddGigShowSegue" {
            if let destinationVC = segue.destination as? GigDetailViewController {
                destinationVC.gigController = gigController
            }
        }
        
        if segue.identifier == "ViewGigShowSegue" {
            if let destinationVC = segue.destination as? GigDetailViewController {
                destinationVC.gigController = gigController
                if let indexPath = tableView.indexPathForSelectedRow?.row {
                    destinationVC.gig = gigController.gigs[indexPath]
                }
            }
        }
        
    }
    
}
