//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Michael on 1/15/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    let gigController = GigController()
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .none
        return df
    }()

    override func viewDidAppear(_ animated: Bool) {
        if gigController.isUserLoggedIn == false {
            performSegue(withIdentifier: "SignUpOrInSegue", sender: self)
        } else {
            // TODO: fetch gigs here
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobCell", for: indexPath)
        let gig = gigController.gigs[indexPath.row]
        
        
        
        // Configure the cell...
        cell.textLabel?.text = gig.title
        cell.detailTextLabel?.text = dateFormatter.string(from: gig.dueDate)
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpOrInSegue" {
            guard let loginVC = segue.destination as? LoginViewController else { return }
            loginVC.gigController = gigController
        }else if segue.identifier == "ShowJobSegue" {
            guard let gigDetailVC = segue.destination as? GigDetailViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            gigDetailVC.gigController = gigController
            gigDetailVC.gig = gigController.gigs[indexPath.row]
        } else if segue.identifier == "AddJobSegue" {
           guard let gigDetailVC2 = segue.destination as? GigDetailViewController else { return }
            gigDetailVC2.gigController = gigController
        }
    }
}
