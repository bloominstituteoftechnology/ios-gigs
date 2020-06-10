//
//  GigsTableViewController.swift
//  gigs
//
//  Created by Keri Levesque on 2/12/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    //MARK: Properties
    let gigController = GigController()
    let dateFormatter = DateFormatter()
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
          
          // transition to login view if conditions require
          if gigController.bearer == nil {
              performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
          }
        gigController.fetchAllGigs { (result) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
      }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        
        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        cell.detailTextLabel?.text = dateFormatter.string(from: gigController.gigs[indexPath.row].dueDate)

        return cell
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
        // inject dependencies
        if let loginVC = segue.destination as? LoginViewController {
            loginVC.gigController = gigController
            }
        } else if segue.identifier == "ShowGigSegue" {
            if let destinationVC = segue.destination as? GigDetailViewController {
                destinationVC.gigController = gigController
                if let indexPath = tableView.indexPathForSelectedRow {
                    destinationVC.gig = gigController.gigs[indexPath.row]
                }
            }
        } else if segue.identifier == "AddGigSegue" {
            if let destinationVC = segue.destination as? GigDetailViewController {
                destinationVC.gigController = gigController
            }
        }
    }


}
