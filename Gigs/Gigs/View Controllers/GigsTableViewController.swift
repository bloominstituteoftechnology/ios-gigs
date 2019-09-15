//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Jessie Ann Griffin on 9/9/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    // MARK: Properties
    let gigController = GigController()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        } else {
            gigController.fetchAllGigs { (result) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        print(gigController.gigs)
        
        // TODO: fetch gig here
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        
        dateFormatter.dateStyle = .short
        let date = dateFormatter.string(from: gigController.gigs[indexPath.row].dueDate)
        
        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        cell.detailTextLabel?.text = date
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            // inject dependencies
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        } else if segue.identifier == "ShowGigSegue" {
            if let detailVC = segue.destination as? GigsDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                detailVC.gigController = gigController
                detailVC.gig = gigController.gigs[indexPath.row]
            }
        } else {
            if let addGigVC = segue.destination as? GigsDetailViewController {
                addGigVC.gigController = gigController
            }
        }
    }
}
