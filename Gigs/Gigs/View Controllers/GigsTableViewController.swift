//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Ciara Beitel on 9/4/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    var gigController = GigController()
    let df = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
            return
        }
        tableView.reloadData()
    }

    // MARK: - Table View Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gigCell", for: indexPath)
        let gig = gigController.gigs[indexPath.row]
        
        cell.textLabel?.text = gig.title
        
        df.dateStyle = .short
        df.timeStyle = .short
        cell.detailTextLabel?.text = df.string(from: gig.dueDate)
        
        return cell
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        } else if segue.identifier == "ShowGigSegue" {
            if let showGigVC = segue.destination as? GigDetailViewController, let indexPath = tableView.indexPathForSelectedRow {
                showGigVC.gigController = gigController
                showGigVC.gig = gigController.gigs[indexPath.row]
            }
        } else if segue.identifier == "AddGigSegue" {
            if let addGigSegueVC = segue.destination as? GigDetailViewController {
                addGigSegueVC.gigController = gigController
            }
        }
    }
}
