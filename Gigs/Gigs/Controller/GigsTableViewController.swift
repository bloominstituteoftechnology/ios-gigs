//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Bradley Yin on 8/7/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    let gigController = GigController()
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "MM/dd/yy"
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginModalSegue", sender: self)
        }
        print("token", gigController.bearer?.token)
        gigController.fetchAllGigs { (result) in
            guard let sucess = try? result.get(), sucess else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginModalSegue" {
            guard let loginVC = segue.destination as? LoginViewController else { return }
            loginVC.gigController = gigController
        }
        if segue.identifier == "addGigShowSegue" {
            guard let detailVC = segue.destination as? GigDetailViewController else { return }
            detailVC.gigController = gigController
        }
        if segue.identifier == "gigDetailShowSegue" {
            guard let detailVC = segue.destination as? GigDetailViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            detailVC.gigController = gigController
            detailVC.gig = gigController.gigs[indexPath.row]
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobCell", for: indexPath)
        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        let dateToDisplay = gigController.gigs[indexPath.row].dueDate
        cell.detailTextLabel?.text = dateFormatter.string(from: dateToDisplay)
        return cell
    }
}
