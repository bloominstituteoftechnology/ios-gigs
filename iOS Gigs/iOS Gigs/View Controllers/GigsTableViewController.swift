//
//  GigsTableViewController.swift
//  iOS Gigs
//
//  Created by Vici Shaweddy on 9/10/19.
//  Copyright © 2019 Vici Shaweddy. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    let gigController = GigController()
    
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        } else {
            gigController.fetchAllGigs { (_) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        // TODO: fetch gigs here
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)

        let gig = gigController.gigs[indexPath.row]
        
        cell.textLabel?.text = gig.title
        
        cell.detailTextLabel?.text = "Due: \(formatter.string(from: gig.dueDate))"
        

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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Inject dependancies
        if let loginVC = segue.destination as? LoginViewController {
            loginVC.gigController = gigController
        }
        
        if segue.identifier == "AddGigSegue",
            let detailVC = segue.destination as? GigDetailViewController {
            detailVC.gigController = self.gigController
        }
        
        if segue.identifier == "ShowGigSegue",
            let detailVC = segue.destination as? GigDetailViewController{
            guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
            detailVC.gigController = self.gigController
            detailVC.gig = gigController.gigs[indexPath.row]
        }
        
    }

}
