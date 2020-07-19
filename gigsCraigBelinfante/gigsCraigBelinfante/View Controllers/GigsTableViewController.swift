//
//  GigsTableViewController.swift
//  gigsCraigBelinfante
//
//  Created by Craig Belinfante on 7/12/20.
//  Copyright © 2020 Craig Belinfante. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
   
    let df = DateFormatter()
    let reuseIdentifier = "cell"
    private var gigs: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    let apiController = APIController()
   

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
   override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if apiController.bearer == nil {
            performSegue(withIdentifier: "login", sender: self)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = gigs[indexPath.row]
        df.dateStyle = .short
        return cell
    }
    
//    @IBAction func getGigs(_ sender: UIBarButtonItem) {
        
 //   }
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
        if segue.identifier == "ShowGig",
            let detailVC = segue.destination as? GigDetailViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                detailVC.gig = gigs[indexPath.row]
            }
            detailVC.apiController = apiController
        }
       else if segue.identifier == "login" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.apiController = apiController
            }
        }
    }
}
