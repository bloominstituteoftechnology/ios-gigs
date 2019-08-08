//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Alex Shillingford on 8/7/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    let gigController = GigController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LogInSegue", sender: self)
        } else {
            gigController.fetchAllGigs { (result) in
                if let _ = try? result.get() {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        cell.detailTextLabel?.text = dateFormatter.string(from: gigController.gigs[indexPath.row].dueDate)
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LogInSegue" {
            guard let loginVC = segue.destination as? LoginViewController else { return }
            loginVC.gigController = self.gigController
        } else if segue.identifier == "ViewGigSegue" {
            guard let index = self.tableView.indexPathForSelectedRow?.item else { return }
            guard let detailVC = segue.destination as? GigDetailViewController else { return }
            detailVC.gigController = self.gigController
            detailVC.gig = gigController.gigs[index]
        } else if segue.identifier == "AddGigSegue" {
            guard let addGigVC = segue.destination as? GigDetailViewController else { return }
            addGigVC.gigController = self.gigController
        }
    }
    

}
