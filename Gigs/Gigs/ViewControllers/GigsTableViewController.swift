//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Cora Jacobson on 7/11/20.
//  Copyright © 2020 Cora Jacobson. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    let gigController = GigController()
    let df = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        if gigController.bearer == nil {
            performSegue(withIdentifier: "loginModalSegue", sender: self)
        } else {
            gigController.getGigs { (result) in
                if let gigs = try? result.get() {
                    DispatchQueue.main.async {
                        self.gigController.gigs = gigs
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gigCell", for: indexPath)
        let gig = gigController.gigs[indexPath.row]
        cell.textLabel?.text = gig.title
        df.dateStyle = .short
        cell.detailTextLabel?.text = df.string(from: gig.dueDate)
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginModalSegue" {
            if let signInVC = segue.destination as? SignInViewController {
                signInVC.gigController = gigController
            }
        } else if segue.identifier == "addGigShowSegue" {
            if let gigDetailVC = segue.destination as? GigDetailViewController {
                gigDetailVC.gigController = gigController
            }
        } else if segue.identifier == "viewGigShowSegue" {
            if let gigDetailVC = segue.destination as? GigDetailViewController {
                gigDetailVC.gigController = gigController
                if let indexPath = tableView.indexPathForSelectedRow {
                    gigDetailVC.gig = gigController.gigs[indexPath.row]
                }
            }
        }
    }

}
