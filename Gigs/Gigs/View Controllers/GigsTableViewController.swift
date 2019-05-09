//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Jeffrey Carpenter on 5/9/19.
//  Copyright © 2019 Jeffrey Carpenter. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    let gigController = GigController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: "ShowLoginScreen", sender: self)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)

        return cell
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowLoginScreen" {
            guard let destinationVC = segue.destination as? LoginViewController else { return }
            destinationVC.gigController = gigController
        }
        
        if segue.identifier == "ShowGigDetail" || segue.identifier == "ShowAddGig" {
            guard let destinationVC = segue.destination as? GigDetailViewController else { return }
            destinationVC.gigController = gigController
            if segue.identifier == "ShowGigDetail" {
                guard let indexPath = tableView.indexPathForSelectedRow else { return }
                destinationVC.gig = gigController.gigs[indexPath.row]
            }
        }
    }
}
