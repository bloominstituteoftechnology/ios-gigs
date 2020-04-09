//
//  GigsTableViewController.swift
//  ios-gigs
//
//  Created by Shawn James on 4/7/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    private let gigController = GigController()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: "ShowLogin", sender: self)
        } else {
            gigController.getAllGigs { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(_):
                    print("Failed fetching gigs.")
                }
            }        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gigController.gigs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigTableViewCell", for: indexPath)
        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        cell.detailTextLabel?.text = dateFormatter.string(from: gigController.gigs[indexPath.row].dueDate)
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
        if segue.identifier == "ShowLogin" {
            guard let loginViewController = segue.destination as? LoginViewController else { return }
            
            loginViewController.gigController = gigController
        } else if  segue.identifier == "ShowGig" {
            guard let detailViewController = segue.destination as? GigDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow
                else { return }
            
            detailViewController.gigController = gigController
            detailViewController.gig = gigController.gigs[indexPath.row]
        } else if segue.identifier == "AddGig" {
            guard let detailViewController = segue.destination as? GigDetailViewController else { return }
            
            detailViewController.gigController = gigController
        }
    }
    
}
