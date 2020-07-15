//
//  GigsTableViewController.swift
//  gig
//
//  Created by Gladymir Philippe on 7/10/20.
//  Copyright © 2020 Gladymir Philippe. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    
    var gigController = GigController()
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = .short
    }

    override func viewDidAppear(_ animated: Bool) {
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        }
        
        gigController.getAllGigs { (result) in
            if let gigs = try? result.get() {
                DispatchQueue.main.async {
                    self.gigController.gigs = gigs
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "gigCell", for: indexPath)

        let gig = gigController.gigs[indexPath.row]
        cell.textLabel?.text = gig.title
        cell.detailTextLabel?.text = ("Due: \(dateFormatter.string(from: gig.dueDate))")

        return cell
    }

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        } else if segue.identifier == "AddGigSegue" {
            if let detailVC = segue.destination as? GigDetailViewController {
                detailVC.gigController = gigController
            }
        } else if segue.identifier == "ShowGigSegue" {
            if let showVC = segue.destination as? GigDetailViewController {
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
            showVC.gigController = gigController
            showVC.gig = gigController.gigs[selectedIndexPath.row]
            }
        }
    }

}
