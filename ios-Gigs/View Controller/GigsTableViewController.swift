//
//  GigsTableViewController.swift
//  ios-Gigs
//
//  Created by Angelique Abacajan on 12/4/19.
//  Copyright © 2019 Angelique Abacajan. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    struct PropertyKeys {
        static let cell = "GigCell"
        static let loginSegue = "SignInModalSegue"
        static let detailSegue = "ShowDetailSegue"
        static let addSegue = "ShowAddGigSegue"
    }
    
    let gigController = GigController()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: PropertyKeys.loginSegue, sender: self)
        } else {
            gigController.fetchGigs { result in
                
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(gigController.gigs.count)
        return gigController.gigs.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.cell, for: indexPath)
        
        
        let gig = gigController.gigs[indexPath.row]
        cell.textLabel?.text = gig.jobTitle
        
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
        if segue.identifier == PropertyKeys.loginSegue {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        } else if segue.identifier == PropertyKeys.detailSegue {
            if let indexPath = tableView.indexPathForSelectedRow,
                let loginVC = segue.destination as? GigDetailViewController {
                loginVC.gig = gigController.gigs[indexPath.row]
                loginVC.gigController = gigController
            }
        } else if segue.identifier == PropertyKeys.addSegue {
            if let loginVC = segue.destination as? GigDetailViewController {
                loginVC.gigController = gigController
            }
        }
    }
    
    
}
