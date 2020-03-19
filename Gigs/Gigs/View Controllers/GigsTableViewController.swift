//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by macbook on 10/2/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    //private var gigs: [String] = []
    
    var gigController = GigController()
    //TODO: - This instance of GigController will be used to perform network calls to get the gigs from the API, and be passed to the other view controllers to perform whatever API calls they need to do as well.
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if gigController.bearer == nil {
            // TODO: - If it is, then perform the manual segue you made to the LoginViewController
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)

        } //else {
            // TODO: TOMORROW fetch gigs here
        //}
    }

    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        
        
        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        //cell.detailTextLabel.text = gigController.gigs[indexPath].
        
//   TODO: - Use a DateFormatter to take the Gig's dueDate property and make it into a more user-friendly readable string and place it in the detail text label of the cell.
//
//           DateFormatters are "expensive" to create. It is better to just create a stored property of type DateFormatter on the GigsTableViewController rather than initializing a date formatter in the cellForRowAt and effectively making a new date formatter for every cell in your table view.

        
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
        if segue.identifier == "LoginViewModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
            // TODO: Implement prepare(for segue to pass the necessary information to the destination view controller. You should have three segues you need to cover.
            
        }
        
    }
    

}
