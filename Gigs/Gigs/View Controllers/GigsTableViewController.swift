//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Elizabeth Wingate on 2/12/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
  let gigController = GigController()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigsCell", for: indexPath)
        
        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        cell.detailTextLabel?.text = dateFormatter.string(from: gigController.gigs[indexPath.row].dueDate)
        
        
        return cell
    }
       // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "LoginViewModalSegue" {
                if let destinationVC = segue.destination as? LoginViewController {
                    destinationVC.gigController = gigController
                }
            } else if segue.identifier == "ShowGig" {
                if let destinationVC = segue.destination as? GigDetailViewController {
                    destinationVC.gigController = gigController
                    if let indexPath = tableView.indexPathForSelectedRow {
                        destinationVC.gig = gigController.gigs[indexPath.row]
                    }
                }
            } else if segue.identifier == "AddGig" {
                if let destinationVC = segue.destination as? GigDetailViewController {
                    destinationVC.gigController = gigController
                }
            }
        }

    }
