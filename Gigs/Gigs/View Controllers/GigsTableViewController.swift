//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Bronson Mullens on 5/8/20.
//  Copyright © 2020 Bronson Mullens. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    // MARK: - Properties
    var gigController = GigController()
    var dateFormatter: DateFormatter {
        let formatter: DateFormatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginSegue", sender: self)
        } else {
            gigController.getGigs { (result) in
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
        let currentGig = gigController.gigs[indexPath.row]
        cell.textLabel?.text = currentGig.title
        cell.detailTextLabel?.text = dateFormatter.string(from: currentGig.dueDate)

        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "LoginSegue":
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        case "AddGig":
            if let addGigVC = segue.destination as? GigDetailViewController {
                addGigVC.gigController = gigController
            }
        case "ShowGig":
            if let gigDetailVC = segue.destination as? GigDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                gigDetailVC.gigController = gigController
                gigDetailVC.gig = gigController.gigs[indexPath.row]
            }
        default:
            break
        }
    }

}
