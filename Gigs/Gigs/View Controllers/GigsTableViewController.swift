//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by morse on 10/30/19.
//  Copyright © 2019 morse. All rights reserved.
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
    var gigs: [Gig]? {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: PropertyKeys.loginSegue, sender: self)
        } else {
            gigController.fetchGigs { result in
                let theGigs = try? result.get()
                
                DispatchQueue.main.async {
                    self.gigs = theGigs
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return gigs?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.cell, for: indexPath)

        guard let gigs = gigs else { return UITableViewCell() }
        let gig = gigs[indexPath.row]
        cell.textLabel?.text = gig.title

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
        if segue.identifier == PropertyKeys.loginSegue {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        } else if segue.identifier == PropertyKeys.detailSegue {
            if let indexPath = tableView.indexPathForSelectedRow,
                let gigs = gigs,
                let loginVC = segue.destination as? GigDetailViewController {
                loginVC.gig = gigs[indexPath.row]
                loginVC.gigController = gigController
            }
        } else if segue.identifier == PropertyKeys.addSegue {
            if let loginVC = segue.destination as? GigDetailViewController {
                loginVC.gigController = gigController
            }
        }
    }
    

}
