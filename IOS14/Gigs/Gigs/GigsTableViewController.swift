//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Ufuk Türközü on 12.02.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    let gigController = GigController()
    
    var formatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .none
        return df
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginManualSegue", sender: self)
        } else {
            gigController.fetchAllGigs { result in
                
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

        // Configure the cell...
        let gig = gigController.gigs[indexPath.row]
        cell.textLabel?.text = gig.title
        cell.detailTextLabel?.text = formatter.string(from: gig.dueDate)

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginManualSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        } else if segue.identifier == "ShowGigDetailSegue" {
            if let detailVC = segue.destination as? GigDetailViewController {
                detailVC.gigController = gigController
                if let indexPath = tableView.indexPathForSelectedRow {
                    let gig = gigController.gigs[indexPath.row]
                    detailVC.gig = gig
                }
            }
        } else if segue.identifier == "AddGigSegue" {
            if let detailVC = segue.destination as? GigDetailViewController {
                detailVC.gigController = gigController
            }
        }
    }

}
