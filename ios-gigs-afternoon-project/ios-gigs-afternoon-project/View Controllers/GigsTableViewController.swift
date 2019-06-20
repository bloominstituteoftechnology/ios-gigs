//
//  GigsTableViewController.swift
//  ios-gigs-afternoon-project
//
//  Created by Alex Shillingford on 6/19/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    // MARK: - Properties
    private let gigController = GigController()
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gigController.bearer == nil {
            performSegue(withIdentifier: "SignUpModalSegue", sender: self)
        } else {
            gigController.fetchingAllGigs { (result) in
                if let gigs = try? result.get() {
                    DispatchQueue.main.async {
                        self.gigController.gigs = gigs
                    }
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
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let dateString = dateFormatter.string(from: gigController.gigs[indexPath.row].dueDate)
        
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        cell.detailTextLabel?.textColor = .white
        cell.detailTextLabel?.text = dateString
        
        // Configure the cell...

        return cell
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // inject dependencies
        if segue.identifier == "SignUpModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = self.gigController
            }
        } else if segue.identifier == "ShowGigSegue",
            let detailVC = segue.destination as? GigDetailViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                detailVC.gig = gigController.gigs[indexPath.row]
            }
            detailVC.gigController = self.gigController
        }
    }
}
