//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Isaac Lyons on 10/2/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    let gigController = GigController()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = gigController.bearer {
            gigController.fetchAllGigs { (result) in
                do {
                    let gigs = try result.get()
                    
                    DispatchQueue.main.async {
                        self.gigController.gigs = gigs
                        self.tableView.reloadData()
                    }
                } catch {
                    NSLog("Error fetching gigs: \(error)")
                }
            }
        } else {
            self.performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)

        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        gigController.dateFormatter.dateStyle = .short
        gigController.dateFormatter.timeStyle = .short
        let dateText = gigController.dateFormatter.string(from: gigController.gigs[indexPath.row].dueDate)
        cell.detailTextLabel?.text = dateText

        return cell
    }

    //MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue",
            let loginVC = segue.destination as? LoginViewController {
            loginVC.gigController = gigController
        } else if let gigDetailVC = segue.destination as? GigDetailViewController {
            gigDetailVC.gigController = gigController
            if segue.identifier == "GigDetailShowSegue",
                let indexPath = tableView.indexPathForSelectedRow {
                gigDetailVC.gig = gigController.gigs[indexPath.row]
            }
        }
    }

}
