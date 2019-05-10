//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Lisa Sampson on 5/9/19.
//  Copyright © 2019 Lisa M Sampson. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    // MARK: - Properties
    let gigController = GigController()
    let authController = AuthenticationController()

    // MARK: - View Loading Methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if authController.bearer == nil {
            performSegue(withIdentifier: "SignInUpSegue", sender: self)
        } else {
            gigController.bearer = authController.bearer
            gigController.fetchAllGigs { (error) in
                if let error = error {
                    NSLog("Error fetching all gigs: \(error)")
                    return
                }
                
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
        
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .none
        
        cell.textLabel?.text = gig.title
        cell.detailTextLabel?.text = "Due: \(df.string(from: gig.dueDate))"

        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignInUpSegue" {
            guard let loginVC = segue.destination as? LoginViewController else { return }
            loginVC.authController = authController
            
        } else if segue.identifier == "CreateGig" {
            guard let detailVC = segue.destination as? GigDetailViewController else { return }
            detailVC.gigController = gigController
            
        } else if segue.identifier == "ViewGig" {
            guard let detailVC = segue.destination as? GigDetailViewController else { return }
            detailVC.gigController = gigController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            detailVC.gig = gigController.gigs[indexPath.row]
        }
    }
}
